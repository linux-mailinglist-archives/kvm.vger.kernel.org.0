Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D3D14F27E
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgAaTDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 14:03:37 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39045 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgAaTDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 14:03:37 -0500
Received: by mail-lj1-f194.google.com with SMTP id o15so2652248ljg.6
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 11:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4VxK/MMCQW+dDkX8QecLocFy8dYcEu2g9dKlDlJzkls=;
        b=Q9Evdpky0V2PYOXzxUeE+Z0wqX2lKAGCp3nVViRW/lRXQ5YgmyuYZxzqoAY8Wyhmwm
         dQUvSnIuv5+2JkLzQBDvrI9/mHezfih4rZs5oNUSWIgveXLWll3Xv8Ze288fwOVtZRfN
         97QULoaV14HQwzYfA78+hJCh/lzyKFL4WmevU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VxK/MMCQW+dDkX8QecLocFy8dYcEu2g9dKlDlJzkls=;
        b=PXdUIyiJQC2rm6kjP4UwhhpMXz0funJPXofZDtcVgxrkoAvXykczgidIEPsJTX/ZEp
         kbFZcLP5rV3R1AdMHBmv/osaMZXl1fT52m/NMGysLivwOGLz1qWGnVP7Sgd2PhdIHKi5
         ejbOVcsJ4tmBPHsYCQnNC4vYE6AZRy66v6deeB+vdLz4YzkUYOz9uwnfaBeLoP/a0Dr1
         BdF3Ed/iADuhU7KZ4lStt4vduYvUD+1MddtAkiuErubZrfrXwtelbkrKY9tlwzfpAH5Z
         3fk9wK6nLI4B9BWncONw/YGZdB0y3fqv3vUPoKku3Gtd0rdte0dsssaso/44XaNh1r8G
         PWWw==
X-Gm-Message-State: APjAAAUC/esY0wzbSDLGFBnzSQD6b/iKtJmhmTdCJULaC0z7N9KOHz2B
        MOfVcMLgSyXiUiYyZL3U9o4wIJ5O7ag=
X-Google-Smtp-Source: APXvYqzCTz/jWuQfZpo64icvkrtetX2t9rj8t/ooPxv1EHNFxmmvPbH8E5zgwf/k6bqFVlZm4kvwJg==
X-Received: by 2002:a2e:8490:: with SMTP id b16mr6802808ljh.282.1580497414675;
        Fri, 31 Jan 2020 11:03:34 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id p9sm5130283ljg.55.2020.01.31.11.03.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 11:03:33 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id w1so8210324ljh.5
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 11:03:33 -0800 (PST)
X-Received: by 2002:a2e:461a:: with SMTP id t26mr6842099lja.204.1580497413314;
 Fri, 31 Jan 2020 11:03:33 -0800 (PST)
MIME-Version: 1.0
References: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com> <20200131185341.GA18946@linux.intel.com>
In-Reply-To: <20200131185341.GA18946@linux.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 31 Jan 2020 11:03:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjoLqJ+zQQq2S3EmoAjOsY700GAPTCkna-RUG0T+4wYqA@mail.gmail.com>
Message-ID: <CAHk-=wjoLqJ+zQQq2S3EmoAjOsY700GAPTCkna-RUG0T+4wYqA@mail.gmail.com>
Subject: Re: [GIT PULL] First batch of KVM changes for 5.6 merge window
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@suse.de>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 10:53 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> I assume the easiest thing would be send a cleanup patch for vmxfeatures.h
> and route it through the KVM tree?

Probably. The KVM side is the only thing that seems to use the
defines, so any names changes should impact only them (we do have that
mkcapflags.sh script, but that should react automatically to any
changes in the #define names)

And this is obviously not a big deal, I just noticed the discrepancies
when doing that resolution.

                    Linus
