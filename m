Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0216997A6
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjBPOkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjBPOk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:40:28 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF443D089
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:40:26 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id g14so2157449ljh.10
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ydQoB2d1DBOxxzzvnSFSVJzz2PRGXznjBzHfFMDCDpA=;
        b=IO6Ncws/QosHsUnae+BY7lwjs8rJd2917RvOF3YhkbHefruHGlBgvPrPSEQvHA2coR
         JbM4JfVbzhZkAlvTAwa9d73uQ0PQFYDaNr3ccItetitKIXKvSWgRQgX/R6z8U4+LYbps
         V9hQlgRMwGO4LyahCqvK9S7gOKjNVgKojzUigxZTOhUcmV3O0tfuExM9vvVXXYtckDpk
         X1Eqb5e9A8Nl+ZQRA8wHZFcYypl3LCZ2N7B7Y8/aROoFWJ4eQYbeVgRlzY/UCswbz1nH
         Mht7v20dv1+xSO/7cM/dLXJbG0H7TnvUipUUAne/GHv3wCYEkqSY/74omYbIyXPkylWZ
         N+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ydQoB2d1DBOxxzzvnSFSVJzz2PRGXznjBzHfFMDCDpA=;
        b=SFsOwSFpLCH7RyOFIzKSF+Xwf5y6nEmF+ALvBoMqyqdHMr5yiXpSQwhZAhqOPuwJAT
         215RvovtNckFj9oAbHahJA2vCCiY63qg+p4RO4nAsnM4Lk7jyCI/tMr2jXeP3HNqQ+Rq
         wIgUHbrui7mYIYYQlBfVM1AEl06M3dzasQULP3gOEj/GY6qvc1WqDiChWaLyLuorxBpD
         Oq9WN2kNBTXNpmhDF7Lx5UgBANq0brZYWwDl0EcODopDdqjolKKAT7I3Hr7klpmpK7P9
         AxNqxymc8gxNe61zlqHzuHc83IcmHGUL8TzxgCo6MpYqjJNjevYPBrs5r+UwPJdbjEHh
         UEZQ==
X-Gm-Message-State: AO0yUKVHclS/hy5WXeqjY6TvxMvCZee1uL/kLH0p/NSU110Wafnfd0rG
        1iylLzQlC5w8a3AuDu3Rsx+N/3VbN66im3/bfMGeSg==
X-Google-Smtp-Source: AK7set/q4edAv9G0kgSV25v9QSfAt30HAKvCFpdQaR6/O11KR/FDHKRuV7k9QxXsfOBMCrTa7344HC18I3VpBae89jc=
X-Received: by 2002:a05:651c:1a2c:b0:293:4da7:669a with SMTP id
 by44-20020a05651c1a2c00b002934da7669amr1056296ljb.2.1676558424681; Thu, 16
 Feb 2023 06:40:24 -0800 (PST)
MIME-Version: 1.0
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
In-Reply-To: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 16 Feb 2023 07:40:13 -0700
Message-ID: <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 1:07 PM Sagi Shahar <sagis@google.com> wrote:
>
> TL;DR
> Marking an SEV VM as dead after intra-host migration prevents cleanly tearing
> down said VM.
>
> We are testing our POC code for TDX copyless migration and notice some
> issues. We are currently using a similar scheme to the one used for
> SEV where the VM is marked as dead after the migration is completed
> which prevents any other IOCTLs from being triggered on the VM.
>
> From what we are seeing, there are at least 2 IOCTLs that VMM is
> issuing on the source VM after the migration is completed. The first
> one is KVM_IOEVENTFD for unwiring an eventfd used for the NVMe admin
> queue during the NVMe device unplug sequence. The second IOCTL is
> KVM_SET_USER_MEMORY_REGION for removing the memslots during VM
> destruction. Failing any of these IOCTLs will cause the migration to
> fail.
>
> I ran 2 simple experiments to test the behavior of these IOCTLs.
>
> First experiment was removing the code which marks the VM as dead.
> After a small fix to the TDX migration logic it looks like both IOCTLs
> can succeed even after the VM got migrated.
>
> Second experiment was to always return success if the VM is marked as
> dead. This simulates the case where these IOCTLs never get called from
> VMM after the migration.
>
> In both cases I'm seeing the same behavior in the overall migration
> process. I'm getting a cgroup related error where it fails to delete
> the CGROUP_CPU file but my guess is that this is not related to the
> IOCTL issue.
>
> I can see 3 options:
>
> 1) If we want to keep the vm_dead logic as is, this means changing to
> VMM code in some pretty hacky way. We will need to distinguish between
> regular VM shutdown to VM shutdown after migration. We will also need
> to make absolutely sure that we don't leave any dangling data in the
> kernel by skipping some of the cleanup stages.
>
> 2) If we want to remove the vm_dead logic we can simply not mark the
> vm as dead after migration. It looks like it will just work but might
> create special cases where IOCTLs can be called on a TD which isn't
> valid anymore. From what I can tell, some of these code paths are
> already  protected by a check if hkid is assigned so it might not be a
> big issue. Not sure how this will work for SEV but I'm guessing
> there's a similar mechanism there as well.
>
> 3) We can also go half way and only block certain memory encryption
> related IOCTLs if the VM got migrated. This will likely require more
> changes when we try to push this ustream since it will require adding
> a new field for vm_mem_enc_dead (or something similar) in addition to
> the current vm_bugged and vm_dead.
>
> Personally, I don't want to go with option (1) since it sounds quite
> risky to make these kind of changes without fully understanding all
> the possible side effects.
>
> I prefer either option (2) or (3) but I don't know which one will be
> more acceptable by the community.

I agree option 2 or 3 seem preferable. Option two sounds good to me, I
am not sure why we needed to disable all IOCLTs on the source VM after
the migration. I was just taking feedback on the review.

We have the ASID similar to the HKID in SEV. I don't think the code
paths are already protected like you mention TDX is but that seems
like a simple enough fix. Or maybe it's better to introduce a new
VM_MOVED like VM_BUGGED and VM_DEAD which allows most IOCTLs but just
disables running vCPUs.

What about option 4. Remove the VM_DEAD on migration and do nothing
else. Userspace can easily make errors which cause the VM to be
unusable. Does this error path really need support from KVM? I don't
think it would violate the guests' security properties with SEV for
SEV-ES. With SEV we can already use the mirror VM functionality to add
more vCPUs, and with SEV-ES after the migration the source vCPUs are
unusable because they lack VMSAs that are part of the guest from
launch time.
