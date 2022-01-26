Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7856349D0AA
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiAZRY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiAZRY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:24:27 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C45C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:24:27 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d18so208804plg.2
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BwB9d/7Tq/xB798GOJXJ0kZ9fYWtI6hgc0A8KgtQUJw=;
        b=LiomPXZUIWdg3C4oKu49AivjVUHNrDnAEyiIy6FUPkXkMTX9AF79pMwVOQjDKqs8PI
         5VTUc6BU9KJbnD10qWze31Wx2Jy73xa3TmX4AavxkPKQHNU2kIf3tiul2XFsD2yH5OW3
         Ql3R8qX1LfcHzdVRqkH9KuTSAQGnpOB+/lWMs58s4LYIctvXtkuAtuI7EVFP6qTpJj2G
         +X+ze2a7o+AVp+JTQthcOR2maD509xWwh75dX1yNMIPHiwhkHD79gxgE5FTibmHElsC0
         OC7WFv1srwzgpNOHGLw/w5WPbJ2BYGVoM0JMl+ZK1fdqUHDsVzFRr2ITDmDGUAGJipxx
         xgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BwB9d/7Tq/xB798GOJXJ0kZ9fYWtI6hgc0A8KgtQUJw=;
        b=abb2TGIpO6phyTS++E2aq/m8JUnmPJW3Gb/bJ/vHgHc7SLkxxyTG0HI/nfgdEC3fxV
         6J00a6It8Wi+IQj5A7L0aDCiMBD8fygDnt1xYai39qtzEGFmpd6BTqf6/13YOgmbR/ok
         e159BQmdC3dmXL/jayFJgo4SzWCiV/aPmL7Txjzi6hQshS7Q3JSolEPkjXIO0aNdeNZB
         TYS5p8kSUDAAYzWgnr/AsDGxvPP/HI9EWYo1BWu9gvEy7/VCSWc73JH+A042D4fhqsiR
         h+DpJwX4JvX2Nehp8dnmtrNxnqofeS4GlSiaoHFp/6eo9dL8sdwfn9Qv8zqEv8DicPhk
         Yq7A==
X-Gm-Message-State: AOAM531qKrGKy5vMR3mL8o/ZNKsAPIdzo2wIP7WowE3TILnCdsgAY5UE
        9fuWVCQfI/k6wQ4AZ+qsO8qM3A==
X-Google-Smtp-Source: ABdhPJxjWZIU+BjoneOeCuxV0UTvnO+oWxfIHvDeB0avkFkHAGEHJYdWa72Ul+sttaTbbwsQpG4dHg==
X-Received: by 2002:a17:902:bd4b:b0:14a:e79a:c146 with SMTP id b11-20020a170902bd4b00b0014ae79ac146mr24603300plx.33.1643217866729;
        Wed, 26 Jan 2022 09:24:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o4sm15126137pgs.3.2022.01.26.09.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:24:26 -0800 (PST)
Date:   Wed, 26 Jan 2022 17:24:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, kvm@vger.kernel.org
Subject: Re: orphan section warnings while building v5.17-rc1
Message-ID: <YfGDxlRzjklaYz95@google.com>
References: <97ce2686-205b-8c46-fd24-116b094a7265@gmail.com>
 <YfF9mqcNVYLVERjl@google.com>
 <769dc0cb-e38a-4139-d0da-4019b83047cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <769dc0cb-e38a-4139-d0da-4019b83047cb@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Paolo Bonzini wrote:
> On 1/26/22 17:58, Sean Christopherson wrote:
> > On Tue, Jan 25, 2022, Pavel Skripkin wrote:
> > > Hi kvm developers,
> > > 
> > > while building newest kernel (0280e3c58f92b2fe0e8fbbdf8d386449168de4a8) with
> > > mostly random config I met following warnings:
> > > 
> > >    LD      .tmp_vmlinux.btf
> > > ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> > > in section `.fixup'
> > >    BTF     .btf.vmlinux.bin.o
> > >    LD      .tmp_vmlinux.kallsyms1
> > > ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> > > in section `.fixup'
> > >    KSYMS   .tmp_vmlinux.kallsyms1.S
> > >    AS      .tmp_vmlinux.kallsyms1.S
> > >    LD      .tmp_vmlinux.kallsyms2
> > > ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> > > in section `.fixup'
> > >    KSYMS   .tmp_vmlinux.kallsyms2.S
> > >    AS      .tmp_vmlinux.kallsyms2.S
> > >    LD      vmlinux
> > > ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> > > in section `.fixup'
> > 
> > Yep, xen.c has unnecessary usage of .fixup.  I'll get a patch sent.
> 
> Peter Zijlstra has already posted "x86,kvm/xen: Remove superfluous .fixup
> usage".

That's why this seemed so familiar... :-)
