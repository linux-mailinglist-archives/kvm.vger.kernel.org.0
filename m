Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC2F9DC4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 00:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfKLXIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 18:08:32 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:35769 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfKLXIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 18:08:32 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so17227127ilp.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 15:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMF1zQ7G+/eyZ3P/+ZJfog2eNz9Ge+2rznL4SFkPZvA=;
        b=AFmcL0c7qsu91xh0H/CBmaOyCgNAPYC0ZO2WFRfDQym/phuTH+UiT0E6rOsfXdHhXF
         B/1lMFnyvUO2R4uThWwr4eAHCXJUPtcL9HhIUHpOSB8McYoGVHC1XUH48E1u7yrczlqP
         hTM+1JgLMoyPkhEA45iu2bU/5woD4zG3wMlzdry2YO4qRJbHnDTViF6l7z1G20YaZ8PU
         Ek3LO8am+hPnizsyxGSZ5tIHMlIvuqYyhV5wboh6nqOYw2pDOtG2FDR1jFpOTr1JYz0J
         glprxKn7SgXzCilk9hExkJnhj100lHrWa/mEGO0Vs6z7CZyNFwfgt+TnRWg2v1Zp3hm7
         9xmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMF1zQ7G+/eyZ3P/+ZJfog2eNz9Ge+2rznL4SFkPZvA=;
        b=VufGP+ffSCt/2qG4C23S2JGSRmAMqSMgiw6TaVcDoWUGNVpageaxc+v4Dy59dG1KzY
         lQBTy6/WqiPTAlTCJevsUEdM5hniyzk7tsKHp3kIqW2feIRX0Ah3RZDw0WPFdtdLDQit
         QdiDYXbzydaPCiJVwu1mcrCGVTERSTQabMBfsZrHn6kbxWwn7Q1FXnN5MQ1g5/J8Bg6E
         Y9kSORdoy2EciuHWY+glmeIXMxjHmBI8kf4E/kstGUOsWPhWcsJhRLk2AEPkLYYiJmr0
         VepNvcGTpqY1VW9WufNsa5F9Tu7GAtnNjaYPrR3kpHZIeyBNSqnNqdKHvgjaUgKBmw5C
         nVLg==
X-Gm-Message-State: APjAAAVpdFGR5iGj4St2dXITtmNf667nU8cdmrYEk00MojSbikv9loiV
        JW+f6mg2XgUwWp6Xu9anpDWniZGKMQlr9jSamI+YmQ==
X-Google-Smtp-Source: APXvYqz0eSGNNx9Ol+LYS74i6rbFx+T+ze8QaHQN/6T0LF4RoCYl3jjyW34LVpQvPczMGTF6bNETQH2b/ajBlkcn3RM=
X-Received: by 2002:a92:c10f:: with SMTP id p15mr403067ile.119.1573600110805;
 Tue, 12 Nov 2019 15:08:30 -0800 (PST)
MIME-Version: 1.0
References: <20191111122621.93151-1-liran.alon@oracle.com>
In-Reply-To: <20191111122621.93151-1-liran.alon@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 Nov 2019 15:08:19 -0800
Message-ID: <CALMp9eTEyYzA-LDrRZzaLtqCJHgQr7WOFDa6xxZ+g8p3QeB-Kw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Remove check if APICv enabled in SVM
 update_cr8_intercept() handler
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 4:26 AM Liran Alon <liran.alon@oracle.com> wrote:
>
> This check is unnecessary as x86 update_cr8_intercept() which calls
> this VMX/SVM specific callback already performs this check.
>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
