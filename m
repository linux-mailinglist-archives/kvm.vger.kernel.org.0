Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485AC54264D
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbiFHC1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 22:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446785AbiFHCZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 22:25:49 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBAA4B3381
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 15:39:44 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d14so16976207wra.10
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 15:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K458RIwl0S+ioiFb9q6BhBZEP6igJ1vcM1oS0iy4llE=;
        b=qkZmhHTmAVsM9bQoLDmXN8wTqVlvd2UVrZ/mz+y/bY9PphCXZGgHPRsakFVRcXu5aJ
         pZ04V2pv9rTHMt/onY3xurzgs18BBkcF7UtaKDzb4ZXg/0pTfW94UE129RD9Kkrpj7vs
         grZKlOe4EK0DD2Pqrp1DGyUIGBC4V3I+k5N6lzmDnXUZ0beG22M8xQlNh/sPnmupAsf7
         Q63CVRCFUV6sqfyuatSWwheVbm8fm8dCIu6ZSbt3E9bhVrzNTvUI9wGrEsv0BLfu7ri8
         b9HPINaJfXlnLzKKnhcXb4SegUySQMFEr2cPlMyLLruFuW0NCfHLF+c8G8yrg0rE7hkk
         nNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K458RIwl0S+ioiFb9q6BhBZEP6igJ1vcM1oS0iy4llE=;
        b=nu/IaKWO1LOaf0TIazEgqdqhfWBNPUiNsV8R9vFvHNIOsvLw+N0PDwTF4JWcT62OMh
         psxqCPZ0kKHHtLFEDhqcYqWapyE1x/hEses3Xk0/ly3lqlhLs/muMjmUgTgS03uAI+rn
         0NW1LVts6vIrLP5VLYufU5A1W5j+SXofPIhNJko5eDPg+CjLP3wMuBVlYEGwcBrSBdva
         MV2qntZ6Dmu1cWqCz8CvCz54dKAV+/IxNzVD9jjZMOCanPnFie7gAco1o4o5h8f80VR0
         CkeOttspPDjkX2XOOm2afaQN9lt15e+TdpGr/25SeshRSv62YV1w4FhDYhWzAgIY5ikv
         36fA==
X-Gm-Message-State: AOAM53202lTD41YU+dq/uAGwapiONKzD0WwgvEz3/kHf3+J6ypuXMHud
        OLP8NaDLtZdEH6PfZPKkn0wQWYjnSHziUX3Tqcqs9A==
X-Google-Smtp-Source: ABdhPJxDaq9V2MMEiigrquHHUGZwnOdX78QxqTvnOU5iE+xtZ6TJ5vdAVKa3ZGBQRboVwR95hdfWZUjtGPaVIQjuJZM=
X-Received: by 2002:a5d:6c62:0:b0:218:3e13:4b17 with SMTP id
 r2-20020a5d6c62000000b002183e134b17mr12877442wrz.673.1654641582192; Tue, 07
 Jun 2022 15:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-90-will@kernel.org>
In-Reply-To: <20220519134204.5379-90-will@kernel.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 7 Jun 2022 15:39:30 -0700
Message-ID: <CAMn1gO5OqW0s+_CGf22uH=eHL4nCap3ACOQ28TPWpxGVbPpE2A@mail.gmail.com>
Subject: Re: [PATCH 89/89] Documentation: KVM: Add some documentation for
 Protected KVM on arm64
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 8:05 AM Will Deacon <will@kernel.org> wrote:
>
> Add some initial documentation for the Protected KVM (pKVM) feature on
> arm64, describing the user ABI for creating protected VMs as well as
> their limitations.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  .../admin-guide/kernel-parameters.txt         |  4 +-
>  Documentation/virt/kvm/arm/index.rst          |  1 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 96 +++++++++++++++++++
>  3 files changed, 100 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 63a764ec7fec..b8841a969f59 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2437,7 +2437,9 @@
>                               protected guests.
>
>                         protected: nVHE-based mode with support for guests whose
> -                                  state is kept private from the host.
> +                                  state is kept private from the host. See
> +                                  Documentation/virt/kvm/arm/pkvm.rst for more
> +                                  information about this mode of operation.
>
>                         Defaults to VHE/nVHE based on hardware support. Setting
>                         mode to "protected" will disable kexec and hibernation
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index b4067da3fcb6..49c388df662a 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -9,6 +9,7 @@ ARM
>
>     hyp-abi
>     hypercalls
> +   pkvm
>     psci
>     pvtime
>     ptp_kvm
> diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
> new file mode 100644
> index 000000000000..64f099a5ac2e
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pkvm.rst
> @@ -0,0 +1,96 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Protected virtual machines (pKVM)
> +=================================
> +
> +Introduction
> +------------
> +
> +Protected KVM (pKVM) is a KVM/arm64 extension which uses the two-stage
> +translation capability of the Armv8 MMU to isolate guest memory from the host
> +system. This allows for the creation of a confidential computing environment
> +without relying on whizz-bang features in hardware, but still allowing room for
> +complementary technologies such as memory encryption and hardware-backed
> +attestation.
> +
> +The major implementation change brought about by pKVM is that the hypervisor
> +code running at EL2 is now largely independent of (and isolated from) the rest
> +of the host kernel running at EL1 and therefore additional hypercalls are
> +introduced to manage manipulation of guest stage-2 page tables, creation of VM
> +data structures and reclamation of memory on teardown. An immediate consequence
> +of this change is that the host itself runs with an identity mapping enabled
> +at stage-2, providing the hypervisor code with a mechanism to restrict host
> +access to an arbitrary physical page.
> +
> +Enabling pKVM
> +-------------
> +
> +The pKVM hypervisor is enabled by booting the host kernel at EL2 with
> +"``kvm-arm.mode=protected``" on the command-line. Once enabled, VMs can be spawned
> +in either protected or non-protected state, although the hypervisor is still
> +responsible for managing most of the VM metadata in either case.
> +
> +Limitations
> +-----------
> +
> +Enabling pKVM places some significant limitations on KVM guests, regardless of
> +whether they are spawned in protected state. It is therefore recommended only
> +to enable pKVM if protected VMs are required, with non-protected state acting
> +primarily as a debug and development aid.
> +
> +If you're still keen, then here is an incomplete list of caveats that apply
> +to all VMs running under pKVM:
> +
> +- Guest memory cannot be file-backed (with the exception of shmem/memfd) and is
> +  pinned as it is mapped into the guest. This prevents the host from
> +  swapping-out, migrating, merging or generally doing anything useful with the
> +  guest pages. It also requires that the VMM has either ``CAP_IPC_LOCK`` or
> +  sufficient ``RLIMIT_MEMLOCK`` to account for this pinned memory.

I think it would be useful to also add a note to
Documentation/virt/kvm/api.rst saying that ioctl(KVM_RUN) can return
ENOMEM if the VMM does not have CAP_IPC_LOCK or sufficient
RLIMIT_MEMLOCK, since that's where people are going to look when they
see that return value.

Peter
