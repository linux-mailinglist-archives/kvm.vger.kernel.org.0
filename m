Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78DEF859C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 01:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKLAwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 19:52:42 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44430 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfKLAwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 19:52:41 -0500
Received: by mail-oi1-f195.google.com with SMTP id s71so13238555oih.11;
        Mon, 11 Nov 2019 16:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QB/2EOOtEheVMvabRJ6VD9T3rYyPOekYSVrm30KsEVM=;
        b=vF4/jybR1amIAuvvObEE5ivv/pVENQbPtWZ0qrEOEiGRw09Eo6CV2HhvAAmNQDAWH9
         BKyM1fRXS7tqYzlPVadHKDuKMIJTx8LJeL/cjBDN0cNFDKAFF9SxalBg8Cn6Asp7dVu2
         BsfoMdwnh17mVSUPISCvBW0Zu8siyhfUi3yZIWSz+yxFQedzweLr4qEYoDobMejTB83O
         ofDuESer1fDbslBVHh0J5FUIffFZHc84lhXiIn3cU2UFhFwwgCmbkUGY/J3wmCZzjMnA
         8Dyj8UPVO6B0l/+Ft+7RRVzSEjR6gMNc0Am7uYblkIkCfLvIPeJdnVUyKzaIhFWizUwV
         HBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QB/2EOOtEheVMvabRJ6VD9T3rYyPOekYSVrm30KsEVM=;
        b=HUFikBZAEwStE1yYhOg+DYntjosA5Djx5vEQOunjkesMe/szGRsDdUY+rj9FpnArNX
         0zGj/VWQvfiX64XBp/K//HEOaukbLSTmEHw/4S2waIQOglqR7BrjdsamIOUv/fZZHino
         pglHV8cEZ/ob36EZUPNsQxxOgNg4VrFM4p55XXv7dLCrzqRey2Arc3fk4F8MJwMon0N1
         IEufcVw8byC9L8z/6dG2nhwJ7ahHiM+K23U/LHSHSe/8Ux3EEmLCUxVY1JIxOOf5ZIOs
         HP5uNkpg5z1iz7cOBHsTvY9HHnyK1eb/P6tmPMNDZaTrzfVdi2SOzKAoJhAAK6YQ+6vh
         tCeg==
X-Gm-Message-State: APjAAAWE6m6Wzkqq9WXVSrRwcT3dbAqEjdyYQVvKJvceBHngFMndDMy/
        4HkSKG+c88z/+CQYlc6gGg+LbBEYi5RZHwxJkKM=
X-Google-Smtp-Source: APXvYqz+oVwjojg8fzUtnO7U0/K6ucwATVrryredzJkRW59QusJC+b2hCjDNzUIXIYAB3nUyr7/NA9CQc2BnwJXlZBQ=
X-Received: by 2002:aca:4a84:: with SMTP id x126mr1512261oia.47.1573519960931;
 Mon, 11 Nov 2019 16:52:40 -0800 (PST)
MIME-Version: 1.0
References: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 12 Nov 2019 08:52:32 +0800
Message-ID: <CANRm+CzZvTMDZAtd_EY_C7tp_EdCk=mtWLS+H+ZW9xujMKEdbA@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: fix issues with kvm_create_vm failures
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Nov 2019 at 21:26, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Fix problems with the recent introduction of kvm_arch_destroy_vm
> on VM creation failure.  An updated version of the patches already
> sent by Wanpeng.
>
> Paolo
>
> Paolo Bonzini (2):
>   KVM: Fix NULL-ptr defer after kvm_create_vm fails
>   KVM: fix placement of refcount initialization

Looks good to me.

    Wanpeng
