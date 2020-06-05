Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B51EF9AE
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgFENw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 09:52:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32541 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726970AbgFENwx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 09:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591365171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TNgajwZ6pH4Vjw9MsZrw1JgI9fWf69wAvgH4rX7cjS0=;
        b=evTGViaC9Pe5mrF1C5I14UCTghlNpjFnwD8+zpp6xuHHcsI41ojMDOMcRE4IBJA3oTXV0U
        uOX3ocOJO9qsevOxe6Im8NMjU2pgrx67iNzgHgR9nKa+0Z/Qiq7eV2wcJXL6z8F/x3WT6S
        HbRYnOf4sG7cPeKUghfq7e3VArMA9yg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-aVNWp9IcNIS6qo-MW_JKMA-1; Fri, 05 Jun 2020 09:52:49 -0400
X-MC-Unique: aVNWp9IcNIS6qo-MW_JKMA-1
Received: by mail-wr1-f72.google.com with SMTP id t5so3788096wro.20
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 06:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TNgajwZ6pH4Vjw9MsZrw1JgI9fWf69wAvgH4rX7cjS0=;
        b=Dbni9MkFDrxTIilvPTTtDUu4I6JsBEqdaICy8IBX/Un6V7yVDtQJKoT5r9ufeeSzN0
         7UlGOer2SHFsTv0MlPmh4/tf5IyGiRIYchpVaz58jmx5nDHLawkmm9SvGzzsOzaTwHh9
         QAmPeyT3PvLSVk6PgA0MrVniNGSyWIPoujNHcasOdjYJlQLqrPt0o6UruiD2oG4ES1DY
         InUsuXNhamul8C33JarDDJ1pvLZeFk5vgCVeAXG00+KL+mKrdu470kf+Y/bkL3pBcfpv
         aIUHQk7h7B7ccHeHdvNItpimrWGEcor+hsS/DQTL9mLVm4dq7r67BsjD7OSK8cl4N7cd
         YE1w==
X-Gm-Message-State: AOAM532plzh1tDdMTMwe8r9kR1u5cv5jqsZx6iN8b3/qi7xiBFPrhiSu
        be7wYWyyC3/J6diezVJU6oisf+hRV6zdb/zYp8YFz58fOR+VBOCNFW1dW5LDM1ITqDSqV1mNHu9
        KVcDi8h6K2mDm
X-Received: by 2002:a1c:a905:: with SMTP id s5mr2773052wme.120.1591365168148;
        Fri, 05 Jun 2020 06:52:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwk7/zHhGVAlFBCQPg3AKusCOUWCvTDN9/pe8dGGBwZaJAzD1b80eaSdZ277m9s2j74Afeafg==
X-Received: by 2002:a1c:a905:: with SMTP id s5mr2773027wme.120.1591365167901;
        Fri, 05 Jun 2020 06:52:47 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.243.176])
        by smtp.gmail.com with ESMTPSA id u12sm12495225wrq.90.2020.06.05.06.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 06:52:47 -0700 (PDT)
Subject: Re: general protection fault in start_creating
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     syzbot <syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com>,
        eesposit@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000001803d305a7414b66@google.com>
 <87sgf9d45b.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <312a6a94-8325-a04f-2409-ec9ae0c0503a@redhat.com>
Date:   Fri, 5 Jun 2020 15:52:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87sgf9d45b.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 15:38, Vitaly Kuznetsov wrote:
> 
> I think what happens here is one thread does kvm_vm_ioctl_create_vcpu()
> and another tries to delete the VM. The problem was probably present
> even before the commit as both kvm_create_vcpu_debugfs() and
> kvm_destroy_vm_debugfs() happen outside of kvm_lock but maybe it was
> harder to trigger.

I think it wasn't, because:

- you cannot reach kvm_vcpu_release before you have created the file
descriptor, and the patch moved debugfs creation after creation of
the file descriptor

- on the other hand you cannot reach kvm_vm_release during KVM_CREATE_VCPU,
so you cannot reach kvm_destroy_vm either (because the VM file descriptor
holds a reference).  So the bug can only occur for things that are touched
by kvm_vcpu_release, and that is only the debugfs dentry.

I have a patch for this already, which is simply removing the 
debugfs_remove_recursive call in kvm_vcpu_release, but I have forgotten to
send it.  What you have below could work but i don't see a good reason to
put things under kvm->lock.

Paolo

> I think what happens here is one thread does kvm_vm_ioctl_create_vcpu()
> and another tries to delete the VM. The problem was probably present
> even before the commit as both kvm_create_vcpu_debugfs() and
> kvm_destroy_vm_debugfs() happen outside of kvm_lock but maybe it was
> harder to trigger. Is there a reason to not put all this under kvm_lock?
> I.e. the following:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7fa1e38e1659..d53784cb920f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -793,9 +793,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
>         struct mm_struct *mm = kvm->mm;
>  
>         kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
> -       kvm_destroy_vm_debugfs(kvm);
>         kvm_arch_sync_events(kvm);
>         mutex_lock(&kvm_lock);
> +       kvm_destroy_vm_debugfs(kvm);
>         list_del(&kvm->vm_list);
>         mutex_unlock(&kvm_lock);
>         kvm_arch_pre_destroy_vm(kvm);
> @@ -3084,9 +3084,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>         smp_wmb();
>         atomic_inc(&kvm->online_vcpus);
>  
> +       kvm_create_vcpu_debugfs(vcpu);
>         mutex_unlock(&kvm->lock);
>         kvm_arch_vcpu_postcreate(vcpu);
> -       kvm_create_vcpu_debugfs(vcpu);
>         return r;
>  
>  unlock_vcpu_destroy:
> 
> should probably do. The reproducer doesn't work for me (or just takes
> too long so I gave up), unfortunately. Or I may have misunderstood
> everything 

