Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18AD69515E
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 21:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjBMUHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 15:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjBMUHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 15:07:23 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B08B1E296
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 12:07:22 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id b16so16049414ljr.11
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 12:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iqlKthQljO+hW9mSK0eAGBCu0DR9sPIssd74zRvlMnw=;
        b=k9kwOvF6LHVxd8r0m22u6hJ3ushijFXDcQKqJ4qcPQRn9kKucqHSOvBKOWrk7F09S/
         NVC7Ojs3ul0C+uvnJap4Wpm639SvZ0uQk0h7IHRujS7zB/XvBfglewc9FLFgLTb+A3q8
         QqvHWjHcDGE719AErJ4R1z4Ms4wIDla863qxn/Ruw+MCOKnHtNnqaGmQogw6vkGTQqfj
         HuIFNooLAwoSdNESOdNEV58XLTXGiJ8Oaq0mE+nM0WDh9iw6rrWBYVuMGMZ3r/8UEh9a
         wIZb7nHCAkaReEgSRVs/Yj/uy3Q4mLU6mhfaySmF38fhQdVJwfO6nCGNgqDUS50dUJXM
         3l/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iqlKthQljO+hW9mSK0eAGBCu0DR9sPIssd74zRvlMnw=;
        b=LjkWtNzRmCLakTPRpQUepCwrzZEE9FmZGpV0o5BfDmObLBwkSmHGb+4yFKlgS7k5Bf
         v848OuHcsGKbQffA+FPRjs/meHYd/RZlHaMPqI/EpOPRIcm+Ivsvq97Kks//3sUvlygM
         ogqnQ89YjJxKXAsJAk3YV4RpdTUIfVovX53yg4MJIpjSzJtiw/lxeL+VcGvyJiRFWr6D
         VGDRaFx3duy4R/ycWQmxFE3WO1uwlh8tp2BAsa9raTYvcoV52QekGMDFMjK9tOsYaabt
         UTRmaUr/IfBflivV3vcop1psO8xRfn/HYtiHl04xicLFheiHrjICCLk8Oq/vXmE4SR6x
         m+1g==
X-Gm-Message-State: AO0yUKW6Ltk9ctJI60nz6H386R/Hkdp32c+No8mwpLQRNCZCpHg4He+1
        pVMiBbMjOKceWQ4pf2vvZuIrqgAfdaz5jc7ioodVJDSUz1d+yx6+dZs=
X-Google-Smtp-Source: AK7set81ZfbKcahqdF5fl/voYv3m0/F8SDwZk0sIcJJcRirm/kOlLPFDUrB09oCBgWnXaeqoy1EfRNTSWcjnhUkDrD8=
X-Received: by 2002:a2e:be9d:0:b0:293:4ba5:f632 with SMTP id
 a29-20020a2ebe9d000000b002934ba5f632mr52071ljr.10.1676318840027; Mon, 13 Feb
 2023 12:07:20 -0800 (PST)
MIME-Version: 1.0
From:   Sagi Shahar <sagis@google.com>
Date:   Mon, 13 Feb 2023 12:07:08 -0800
Message-ID: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
Subject: Issue with "KVM: SEV: Add support for SEV intra host migration"
To:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ryan Afranji <afranji@google.com>,
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

TL;DR
Marking an SEV VM as dead after intra-host migration prevents cleanly tearing
down said VM.

We are testing our POC code for TDX copyless migration and notice some
issues. We are currently using a similar scheme to the one used for
SEV where the VM is marked as dead after the migration is completed
which prevents any other IOCTLs from being triggered on the VM.

From what we are seeing, there are at least 2 IOCTLs that VMM is
issuing on the source VM after the migration is completed. The first
one is KVM_IOEVENTFD for unwiring an eventfd used for the NVMe admin
queue during the NVMe device unplug sequence. The second IOCTL is
KVM_SET_USER_MEMORY_REGION for removing the memslots during VM
destruction. Failing any of these IOCTLs will cause the migration to
fail.

I ran 2 simple experiments to test the behavior of these IOCTLs.

First experiment was removing the code which marks the VM as dead.
After a small fix to the TDX migration logic it looks like both IOCTLs
can succeed even after the VM got migrated.

Second experiment was to always return success if the VM is marked as
dead. This simulates the case where these IOCTLs never get called from
VMM after the migration.

In both cases I'm seeing the same behavior in the overall migration
process. I'm getting a cgroup related error where it fails to delete
the CGROUP_CPU file but my guess is that this is not related to the
IOCTL issue.

I can see 3 options:

1) If we want to keep the vm_dead logic as is, this means changing to
VMM code in some pretty hacky way. We will need to distinguish between
regular VM shutdown to VM shutdown after migration. We will also need
to make absolutely sure that we don't leave any dangling data in the
kernel by skipping some of the cleanup stages.

2) If we want to remove the vm_dead logic we can simply not mark the
vm as dead after migration. It looks like it will just work but might
create special cases where IOCTLs can be called on a TD which isn't
valid anymore. From what I can tell, some of these code paths are
already  protected by a check if hkid is assigned so it might not be a
big issue. Not sure how this will work for SEV but I'm guessing
there's a similar mechanism there as well.

3) We can also go half way and only block certain memory encryption
related IOCTLs if the VM got migrated. This will likely require more
changes when we try to push this ustream since it will require adding
a new field for vm_mem_enc_dead (or something similar) in addition to
the current vm_bugged and vm_dead.

Personally, I don't want to go with option (1) since it sounds quite
risky to make these kind of changes without fully understanding all
the possible side effects.

I prefer either option (2) or (3) but I don't know which one will be
more acceptable by the community.
