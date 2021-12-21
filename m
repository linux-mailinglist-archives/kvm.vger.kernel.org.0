Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA23447C519
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbhLURgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 12:36:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234411AbhLURgj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 12:36:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640108198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38wgZasIJEmZs748b2lo89aA5pEBSbdco132gIBfpfQ=;
        b=Vqxh0gXkstqEU6IKyEgjFth/8N2J9VJjxMhSP3CghygO700u+g0+etG3BAkBBkPLUfyi4Z
        dksk84YWy7pXjzYqNrtkD1N/T5KNaILHBGFzj8dlrrAHSIb7HaiDSm26eOtbXL9T7eKs3B
        xGtVkX9ZCHocXfOAXTw5+dwT1BCmyZQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-B-U54QozN_OnXyYur9y0kg-1; Tue, 21 Dec 2021 12:36:37 -0500
X-MC-Unique: B-U54QozN_OnXyYur9y0kg-1
Received: by mail-wm1-f71.google.com with SMTP id 205-20020a1c00d6000000b003335d1384f1so1575327wma.3
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 09:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=38wgZasIJEmZs748b2lo89aA5pEBSbdco132gIBfpfQ=;
        b=HkzUObBAsKJfX63Z3CBvQs6NObAbd+qCNIAMW/h+pNo75pADpImbWnLpZ13yplVY/x
         JyWw22CO1LZtEDYB5Qm3M8N77ZmzAIrTzYHe+AC/U67MkwzqZeTSkXd4r8rcjRZKP8ii
         P+oSjUilnUsuJGhKKtRbjylJiNVMdmLYDBwDMq0pDCl3SFBie78Mb4s6S0GNtjNbMGTN
         b6kWcktReZflWzdVQtucVQnetkUyavBPg6SSavnuRcxoPoybdsiMuq/LF/kqB07Yi9wJ
         6Sj4X5H63R+sbZs3fxahKhCazNzDRqRgfYJrHM+QbZ63N2LGceYEoojh8lF7YEUW5OQY
         SKbQ==
X-Gm-Message-State: AOAM530l5aA/1P3egGWiyWG5TU43gUqtuGRsS0W4lEXKIub2XBJj3s8Z
        ofZGaJ+iiMi5zNDcdI97UDibv/6qsYUv8zUHyg4FfSrblVGJP0HTY8HzcA0WRl9vOIJpT4bdbd0
        aW1ECWmNPQfnM
X-Received: by 2002:a1c:1906:: with SMTP id 6mr3644655wmz.19.1640108195312;
        Tue, 21 Dec 2021 09:36:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2MZkhDMyGTenlhqfVlnyPoISPCJianrWoU/KqNuAix/QZPHUHTggMalVz1oo8amaDSvBjdA==
X-Received: by 2002:a1c:1906:: with SMTP id 6mr3644637wmz.19.1640108195019;
        Tue, 21 Dec 2021 09:36:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z17sm2900862wmi.22.2021.12.21.09.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:36:34 -0800 (PST)
Message-ID: <65dd75c0-e0fd-28d2-f5b5-920772b6e791@redhat.com>
Date:   Tue, 21 Dec 2021 18:36:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/3] selftest: Support amx selftest
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com
References: <20211221231507.2910889-1-yang.zhong@intel.com>
 <20211221231507.2910889-4-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211221231507.2910889-4-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/21 00:15, Yang Zhong wrote:
> This selftest do two test cases, one is to trigger #NM
> exception and check MSR XFD_ERR value. Another case is
> guest load tile data into tmm0 registers and trap to host
> side to check memory data after save/restore.
> 
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>

This is a great start, mainly I'd add a lot more GUEST_SYNCs.

Basically any instruction after the initial GUEST_ASSERTs are a 
potential point for GUEST_SYNC, except right after the call to set_tilecfg:

GUEST_SYNC(1)

> +	/* xfd=0, enable amx */
> +	wrmsr(MSR_IA32_XFD, 0);

GUEST_SYNC(2)

> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == 0);
> +	set_tilecfg(amx_cfg);
> +	__ldtilecfg(amx_cfg);

GUEST_SYNC(3)

> +	/* Check save/restore when trap to userspace */
> +	__tileloadd(tiledata);
> +	GUEST_SYNC(1);

This would become 4; here add tilerelease+GUEST_SYNC(5)+XSAVEC, and 
check that state 18 is not included in XCOMP_BV.

> +	/* xfd=0x40000, disable amx tiledata */
> +	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);

GUEST_SYNC(6)

> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
> +	set_tilecfg(amx_cfg);
> +	__ldtilecfg(amx_cfg);
> +	/* Trigger #NM exception */
> +	__tileloadd(tiledata);

GUEST_SYNC(10); this final GUEST_SYNC should also check TMM0 in the host.

> +	GUEST_DONE();
> +}
> +
> +void guest_nm_handler(struct ex_regs *regs)
> +{
> +	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */

GUEST_SYNC(7)

> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> +	/* Clear xfd_err */

Same here, I'd do a GUEST_SYNC(8) and re-read MSR_IA32_XFD_ERR.

> +	wrmsr(MSR_IA32_XFD_ERR, 0);
> +	GUEST_SYNC(2);

This becomes GUEST_SYNC(9).

> +}


> +		case UCALL_SYNC:
> +			switch (uc.args[1]) {
> +			case 1:
> +				fprintf(stderr,
> +					"Exit VM by GUEST_SYNC(1), check save/restore.\n");
> +
> +				/* Compacted mode, get amx offset by xsave area
> +				 * size subtract 8K amx size.
> +				 */
> +				amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
> +				state = vcpu_save_state(vm, VCPU_ID);
> +				void *amx_start = (void *)state->xsave + amx_offset;
> +				void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
> +				/* Only check TMM0 register, 1 tile */
> +				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
> +				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d\n", ret);
> +				kvm_x86_state_cleanup(state);
> +				break;

All GUEST_SYNCs should do save_state/load_state like state_test.c.  Then 
of course you can *also* check TMM0 after __tileloadd, which would be 
cases 4 and 10.

Thanks,

Paolo

> +			case 2:
> +				fprintf(stderr,
> +					"Exit VM by GUEST_SYNC(2), generate #NM exception.\n");
> +				goto done;
> +			}
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +done:
> +	kvm_vm_free(vm);
> +}
> 

