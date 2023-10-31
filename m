Return-Path: <kvm+bounces-199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1017DCED4
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A78B9B20F29
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5101DDFF;
	Tue, 31 Oct 2023 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JX1qAFBE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624B81A5AF
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:14:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E0FC9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698761688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0Rzur0DPYsSsAxdt1Pi/bDYKklT+E5fkG1AqmAajEo=;
	b=JX1qAFBET2PgT4uufK+IAavhWO2wfI4cFdoKi0TgJBViZOljZP3O0rV6hhV+CQlFdp0RBQ
	EALqApHuJXJz+n4RXuMZUK3/s5WtLMsO5he9Zax7VmdtXDl3WrIU1u3U/QkOoXZcZe0Hw/
	cSI5IEJ6j/72EIP2Xd0Jq5ZFurGL+Qs=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-mzsHHn8UMLqbcqWfbu00nw-1; Tue, 31 Oct 2023 10:14:46 -0400
X-MC-Unique: mzsHHn8UMLqbcqWfbu00nw-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-457d9c334f2so1852335137.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761686; x=1699366486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t0Rzur0DPYsSsAxdt1Pi/bDYKklT+E5fkG1AqmAajEo=;
        b=Yge7g566X8eNBUDM/AOxY6ph5pHzGAh6Iil3VK8QtVd9pVMRqV3V1n9psYY6o5gE0t
         c68BVhmKk/ZcLIM8yz3DcUpPEtvrthIWh7SjGmoAp66M2Z8okBJSGhLJ85OHYHpJmjwK
         5Yk8csy9A5484AaaA8Jw7vTb3o0iIoXEIxhzrDCSzWnKIXE4fJ6tImHCd2JvY1Ncmu9D
         bgXqkNx+yej1EZ8zcJQWcpIUa4TgsozkSwfh+0KTpSLfOWc96IZ81mteyTuIl8IJ4UCP
         EQomTCgAdQiUn7jFF1Z+4lmMCbZOaES4s75TcoO+G2aNQUGP3kngrJpKvPvXrSFuW8O8
         N2IA==
X-Gm-Message-State: AOJu0YzRRG5FGmlApjcPaeeU8V08ijfsjShziZNi4/6TgF/2pOoVaV62
	4ho6O8HMMwAw5txPRuS6wTH+EIk/8boV5deN7HJAnYBgZ+PDGOzPverWeLB6kEVeL/I9IPd7SYI
	8uIQOwiiiVyIW+R9ht7J9azIuC/IF
X-Received: by 2002:a05:6102:3d8c:b0:457:a915:5e85 with SMTP id h12-20020a0561023d8c00b00457a9155e85mr12840825vsv.28.1698761686242;
        Tue, 31 Oct 2023 07:14:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2aILnhqixBNcNVNeBm0z/LBexH2dJ9/e2srt+6eIErcEXLvOaCG43iBBOkp/KJnhIZQ53Q3DZhvKlvsGLv0M=
X-Received: by 2002:a05:6102:3d8c:b0:457:a915:5e85 with SMTP id
 h12-20020a0561023d8c00b00457a9155e85mr12840811vsv.28.1698761685982; Tue, 31
 Oct 2023 07:14:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com> <20231027204933.3651381-3-seanjc@google.com>
In-Reply-To: <20231027204933.3651381-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:14:34 +0100
Message-ID: <CABgObfY8Mr29fQwWfLE4fhDUnUnYw8_wQ1UGcBq9i86PncSE=g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Documentation updates for 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 10:49=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Doc updates for 6.7.  The bulk is a cleanup of the kvm_mmu_page docs, whi=
ch are
> sadly already stale because I neglected to update the docs when removing =
the
> TDP MMU's async root zapping :-(
>
> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-docs-6.7

Pulled, thanks.

Paolo

> for you to fetch changes up to b35babd3abea081de0611ce0d5b85281c18c52c7:
>
>   KVM: x86/pmu: Add documentation for fixed ctr on PMU filter (2023-09-27=
 14:23:51 -0700)
>
> ----------------------------------------------------------------
> KVM x86 Documentation updates for 6.7:
>
>  - Fix various typos, notably a confusing reference to the non-existent
>    "struct kvm_vcpu_event" (the actual structure is kvm_vcpu_events, plur=
al).
>
>  - Update x86's kvm_mmu_page documentation to bring it closer to the code
>    (this raced with the removal of async zapping and so the documentation=
 is
>    already stale; my bad).
>
>  - Document the behavior of x86 PMU filters on fixed counters.
>
> ----------------------------------------------------------------
> Jinrong Liang (1):
>       KVM: x86/pmu: Add documentation for fixed ctr on PMU filter
>
> Michal Luczaj (1):
>       KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation
>
> Mingwei Zhang (6):
>       KVM: Documentation: Add the missing description for guest_mode in k=
vm_mmu_page_role
>       KVM: Documentation: Update the field name gfns and its description =
in kvm_mmu_page
>       KVM: Documentation: Add the missing description for ptep in kvm_mmu=
_page
>       KVM: Documentation: Add the missing description for tdp_mmu_root_co=
unt into kvm_mmu_page
>       KVM: Documentation: Add the missing description for mmu_valid_gen i=
nto kvm_mmu_page
>       KVM: Documentation: Add the missing description for tdp_mmu_page in=
to kvm_mmu_page
>
>  Documentation/virt/kvm/api.rst     | 36 +++++++++++++++++++++++--------
>  Documentation/virt/kvm/x86/mmu.rst | 43 ++++++++++++++++++++++++++++++--=
------
>  2 files changed, 61 insertions(+), 18 deletions(-)
>


