Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4598E65C5E9
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbjACSRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238817AbjACSRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:17:20 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5488813EB4
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:17:19 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so13993782pgl.8
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hl1m6owob6L03NijBO7al3lk620qRVaiSafJ4M2A8m4=;
        b=Juf6c0M3QBOfV9ZSCI8ohzVj7mRdQu1neOhQ2eJdcs1PMri5dkm2rR1zvroFHOa/lD
         nlfPteBpn1n5M+04MWVSDTbFORGKdpwuZLEha+YfY6zCOcCZtaysFrtHMLuP+sfo0vqs
         XG4RBposZOmmw6D9b443tBrHbbfiidVpWqxz+SBkTlrBKDEFVq/l29DTjvBPuEHo/Pyv
         GeioeQHUGHMdYskaAZJGuzuofVUCkmulLJ2Kkjl1tnHdoQu7F2mD/7fCZHSYyHCLL3S8
         ptqCujUF0GUXnP0pKox44KqvRYtymYNvGzpIE4dylZnVL+XkgcS4QWikYiUfQDBB8Rkz
         +iIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hl1m6owob6L03NijBO7al3lk620qRVaiSafJ4M2A8m4=;
        b=0HzyV/I2cK01sdJjWzjkRAF18xfHU9FyrfmkePRsrSS48pBUaEi/2NnGJIWa0kguV+
         h9j3xg5d2FeoG98eYVvoGpc46mupmgjaqPOZtgB8aDacBYvdBNHBOPkQKl6CnIYume3K
         xDx2aOyrsAF98t3kKzYC1jXHUvOy3gsZxXaTc6EU07/XlsYmd8yVxCqh+ti4bvhMJOTd
         cvnayRKGHAPEN1udsfls64pX4751h6zu2UURn0vWfDWO4LIphKe9h3FBXqckJ1lz51yi
         We2Nf7SZuqbXdlcI8meDlItJP3dCSUJVZdMx+1wiMZDxncXLBQRgntcL3euZlrza8rlF
         cTLA==
X-Gm-Message-State: AFqh2krzXQdsY3LO1mS2FkOKsrCOO/gKGGCFBAyfDfk0wl2SInsqE3St
        +tstwRLGebTdl9omwdMR5qrzEV1TxsQ5GM3yow==
X-Google-Smtp-Source: AMrXdXtl8YK5hENhsYq1u/WnQ3ynWhmnxnc48c8ukA28XJRLuwX2hjPOB7UhMO9ZIY5MFS/x5JA+x7V22y1x5c/Vtg==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a17:90b:1112:b0:223:dd6f:13b2 with
 SMTP id gi18-20020a17090b111200b00223dd6f13b2mr3246528pjb.56.1672769838642;
 Tue, 03 Jan 2023 10:17:18 -0800 (PST)
Date:   Tue, 03 Jan 2023 10:17:16 -0800
In-Reply-To: <20221215205937.GF3632095@ls.amr.corp.intel.com> (message from
 Isaku Yamahata on Thu, 15 Dec 2022 12:59:37 -0800)
Mime-Version: 1.0
Message-ID: <diqzh6x7lbyr.fsf@google.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
From:   Ackerley Tng <ackerleytng@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com,
        sean.j.christopherson@intel.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Happy to help!

Nope it wasn't any special technique, I was working on the selftests and
made a mistake configuring the TD while initializing it.

While setting up struct kvm_tdx_init_vm, I did not copy the entire
struct kvm_cpuid2.

This reliably reproduces the crash:

--------

// SPDX-License-Identifier: GPL-2.0-only

#include "kvm_util_base.h"
#include <processor.h>

static int tdx_ioctl(int fd, int ioctl_no, uint32_t flags, void *data)
{
	struct kvm_tdx_cmd tdx_cmd;

	memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
	tdx_cmd.id = ioctl_no;
	tdx_cmd.flags = flags;
	tdx_cmd.data = (uint64_t)data;
	return ioctl(fd, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
}

#define XFEATURE_LBR		15
#define XFEATURE_XTILECFG	17
#define XFEATURE_XTILEDATA	18
#define XFEATURE_CET_U          11
#define XFEATURE_CET_S          12

#define XFEATURE_MASK_LBR	(1 << XFEATURE_LBR)
#define XFEATURE_MASK_CET_U	(1 << XFEATURE_CET_U)
#define XFEATURE_MASK_CET_S	(1 << XFEATURE_CET_S)
#define XFEATURE_MASK_CET       (XFEATURE_MASK_CET_U | XFEATURE_MASK_CET_S)
#define XFEATURE_MASK_XTILECFG	(1 << XFEATURE_XTILECFG)
#define XFEATURE_MASK_XTILEDATA	(1 << XFEATURE_XTILEDATA)
#define XFEATURE_MASK_XTILE	(XFEATURE_MASK_XTILECFG |  
XFEATURE_MASK_XTILEDATA)

static void apply_tdx_restrictions(struct kvm_cpuid2 *cpuid_data)
{
	for (int i = 0; i < 100; i++) {
		struct kvm_cpuid_entry2 *e = &cpuid_data->entries[i];

		if (e->function == 0xd && e->index == 0) {
			/*
			 * TDX module requires both XTILE_{CFG, DATA} to be set.
			 * Both bits are required for AMX to be functional.
			 */
			if ((e->eax & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE) {
				e->eax &= ~XFEATURE_MASK_XTILE;
			}
		}

		if (e->function == 0xd && e->index == 1) {
			/*
			 * TDX doesn't support LBR yet.
			 * Disable bits from the XCR0 register.
			 */
			e->ecx &= ~XFEATURE_MASK_LBR;

			/*
			 * TDX modules requires both CET_{U, S} to be set even
			 * if only one is supported.
			 */
			if (e->ecx & XFEATURE_MASK_CET)
				e->ecx |= XFEATURE_MASK_CET;
		}
	}
}

void initialize_td_bad(struct kvm_vm *vm)
{
	const struct kvm_cpuid2 *cpuid;
	int rc;

	/* No guest VMM controlled cpuid information yet. */
	struct kvm_tdx_init_vm init_vm;

	rc = kvm_check_cap(KVM_CAP_X2APIC_API);
	TEST_ASSERT(rc, "TDX: KVM_CAP_X2APIC_API is not supported!");
	rc = kvm_check_cap(KVM_CAP_SPLIT_IRQCHIP);
	TEST_ASSERT(rc, "TDX: KVM_CAP_SPLIT_IRQCHIP is not supported!");

	vm_enable_cap(vm, KVM_CAP_X2APIC_API,
		      KVM_X2APIC_API_USE_32BIT_IDS |
			      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK);
	vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);

	/* Allocate and setup memory for the td guest. */
	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, 1, 0);

	cpuid = kvm_get_supported_cpuid();
	apply_tdx_restrictions((struct kvm_cpuid2 *) cpuid);

	memset(&init_vm, 0, sizeof(init_vm));
	init_vm.attributes = 0;

	/*
	 * Should have been kvm_cpuid2_size(cpuid->nent) instead of
	 * sizeof(*cpuid)
	 */
	memcpy(&init_vm.cpuid, cpuid, sizeof(*cpuid));

	rc = tdx_ioctl(vm->fd, KVM_TDX_INIT_VM, 0, &init_vm);
	TEST_ASSERT(rc == 0, "KVM_TDX_INIT_VM failed: %d %d", rc, errno);
}

static int crash(void)
{
	struct kvm_vm *vm;

	/* Create a TD VM with no memory.*/
	vm = ____vm_create(VM_MODE_DEFAULT, 0, KVM_X86_TDX_VM);

	/* Allocate TD guest memory and initialize the TD.*/
	initialize_td_bad(vm);

	return 0;
}

int main(int argc, char **argv)
{
	/* Disable stdout buffering */
	setbuf(stdout, NULL);

	return crash();
}
