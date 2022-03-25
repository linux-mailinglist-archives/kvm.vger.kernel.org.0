Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2446C4E7D20
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiCYTk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 15:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiCYTif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 15:38:35 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E4D3A0028
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 12:20:03 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id c15so11531126ljr.9
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 12:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f6OY6jYnD9ggP76kczLBVEDdWx4HaHrcu9tKegDaXOE=;
        b=ABrfEtKzcsurwYOLwjRnarw37H6h6hj4BLaDXyg9ei41loj1kwp/8RS2BASMfj2MxL
         nwuFwawdhL/w3HKjR1PbVoNWljUME7JI02QpuG9Tt9zCCOpKH75hhacJgboHz5Tc2Muf
         IYJNM5Tnsd1IqSaRpUrwqNc6zSc4J8hr7ILpolGKbGvazOYrvu3yq34IWgB5jP6LgQP3
         t2As5Be0taPSLy0TU2Q/tnyTKJtF4ttAn7Enx9SZxduLo90d9CLippFIZ7KgjX+svtAv
         rRWGHKJZFV2UCdUXBi8pE+kzkVnlwS6clswAZnEXtvA8zZ/pFXHlzp4UXU/A6XYWTIjf
         Giow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f6OY6jYnD9ggP76kczLBVEDdWx4HaHrcu9tKegDaXOE=;
        b=mJNcBHPA+9Eky2mUILnPHpgNUy/SEOMrMlnIGwnPzbqYFqi1Vyd2db/u5zMIN2kFSM
         EtbgbaJYQ7XFE7LXS4l9vAHfralDqQU+BFUNIAePQI/0jeTKKISA1Jzy/Jhfe2bH/UE7
         yhqa/HvvpW1LoMCPmmJzRY/E8fpasUD5fByoFLfQO4typBCEqjuR7N3hkO/G27l+JAV+
         AGPSbwfcTrCBrtq0Cj7JN8eaw0ryaFnUH4v5wCZvYh0gYMJ0Xk5EOKw9kQ2sL4ehFXi1
         4xDdkmcbP35+FsYfAStmjGCSX5K7SS6QJmLDRQ8NUJtN+O08bO4mqt5ZrhxCsQz4IlNS
         elgQ==
X-Gm-Message-State: AOAM5321p43LWIKT2+9zVzpEldUUDKsVsY/mWqRx7fVyLylIvmlja9fg
        JfYIrjej4YcVT7qz6SjW4ExqNC+pYFE=
X-Google-Smtp-Source: ABdhPJzL+5i3LwqU633yH0kVQDTk9+oD6gJ/DFT2zQoPaB4Fxt+IxrTIMyN4xjJbivJ8I/gSzTaRPg==
X-Received: by 2002:a17:906:6a13:b0:6db:ab28:9f00 with SMTP id qw19-20020a1709066a1300b006dbab289f00mr13018978ejc.296.1648232361676;
        Fri, 25 Mar 2022 11:19:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id s4-20020a170906a18400b006db0a78bde8sm2573123ejy.87.2022.03.25.11.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 11:19:20 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <820368fe-690f-8294-736b-52ddea863fa5@redhat.com>
Date:   Fri, 25 Mar 2022 19:19:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220303154127.202856-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220303154127.202856-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 16:41, David Woodhouse wrote:
> This series adds event channel acceleration for Xen guests. In particular
> it allows guest vCPUs to send each other IPIs without having to bounce
> all the way out to the userspace VMM in order to do so. Likewise, the
> Xen singleshot timer is added, and a version of SCHEDOP_poll. Those
> major features are based on Joao and Boris' patches from 2019.
> 
> Cleaning up the event delivery into the vcpu_info involved using the new
> gfn_to_pfn_cache for that, and that means I ended up doing so for *all*
> the places the guest can have a pvclock.
> 
> v0: Proof-of-concept RFC
> 
> v1:
>   • Drop the runstate fix which is merged now.
>   • Add Sean's gfn_to_pfn_cache API change at the start of the series.
>   • Add KVM self tests
>   • Minor bug fixes
> 
> v2:
>   • Drop dirty handling from gfn_to_pfn_cache
>   • Fix !CONFIG_KVM_XEN build and duplicate call to kvm_xen_init_vcpu()
> 
> v3:
>   • Add KVM_XEN_EVTCHN_RESET to clear all outbound ports.
>   • Clean up a stray #if	1 in a part of the the test case that was once
>     being recalcitrant.
>   • Check kvm_xen_has_pending_events() in kvm_vcpu_has_events() and *not*
>     kvm_xen_has_pending_timer() which is checked from elsewhere.
>   • Fix warnings noted by the kernel test robot <lkp@intel.com>:
>      • Make kvm_xen_init_timer() static.
>      • Make timer delta calculation use an explicit s64 to fix 32-bit build.

I've seen this:

[1790637.031490] BUG: Bad page state in process qemu-kvm  pfn:03401
[1790637.037503] page:0000000077fc41af refcount:0 mapcount:1 
mapping:0000000000000000 index:0x7f4ab7e01 pfn:0x3401
[1790637.047592] head:0000000032101bf5 order:9 compound_mapcount:1 
compound_pincount:0
[1790637.055250] anon flags: 
0xfffffc009000e(referenced|uptodate|dirty|head|swapbacked|node=0|zone=1|lastcpupid=0x1fffff)
[1790637.065949] raw: 000fffffc0000000 ffffda4b800d0001 0000000000000903 
dead000000000200
[1790637.073869] raw: 0000000000000100 0000000000000000 00000000ffffffff 
0000000000000000
[1790637.081791] head: 000fffffc009000e dead000000000100 
dead000000000122 ffffa0636279fb01
[1790637.089797] head: 00000007f4ab7e00 0000000000000000 
00000000ffffffff 0000000000000000
[1790637.097795] page dumped because: nonzero compound_mapcount
[1790637.103455] Modules linked in: kvm_intel(OE) kvm(OE) overlay tun 
tls ib_core rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd 
grace fscache netfs rfkill sunrpc intel_rapl_msr intel_rapl_common 
isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal 
intel_powerclamp coretemp ipmi_ssif iTCO_wdt intel_pmc_bxt irqbypass 
iTCO_vendor_support acpi_ipmi rapl dell_smbios ipmi_si mei_me 
intel_cstate dcdbas ipmi_devintf i2c_i801 intel_uncore 
dell_wmi_descriptor wmi_bmof mei lpc_ich intel_pch_thermal i2c_smbus 
ipmi_msghandler acpi_power_meter xfs crct10dif_pclmul i40e crc32_pclmul 
crc32c_intel megaraid_sas ghash_clmulni_intel tg3 mgag200 wmi fuse [last 
unloaded: kvm]
[1790637.162636] CPU: 12 PID: 3056318 Comm: qemu-kvm Kdump: loaded 
Tainted: G        W IOE    --------- ---  5.16.0-0.rc6.41.fc36.x86_64 #1
[1790637.174878] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 
1.6.11 11/20/2018
[1790637.182618] Call Trace:
[1790637.185246]  <TASK>
[1790637.187524]  dump_stack_lvl+0x48/0x5e
[1790637.191373]  bad_page.cold+0x63/0x94
[1790637.195123]  free_tail_pages_check+0xbb/0x110
[1790637.199656]  free_pcp_prepare+0x270/0x310
[1790637.203843]  free_unref_page+0x1d/0x120
[1790637.207856]  kvm_gfn_to_pfn_cache_refresh+0x2c2/0x400 [kvm]
[1790637.213662]  kvm_setup_guest_pvclock+0x4b/0x180 [kvm]
[1790637.218913]  kvm_guest_time_update+0x26d/0x330 [kvm]
[1790637.224080]  vcpu_enter_guest+0x31c/0x1390 [kvm]
[1790637.228908]  kvm_arch_vcpu_ioctl_run+0x132/0x830 [kvm]
[1790637.234254]  kvm_vcpu_ioctl+0x270/0x680 [kvm]

followed by other badness with the same call stack:

[1790637.376127] page dumped because: 
VM_BUG_ON_PAGE(page_ref_count(page) == 0)

I am absolutely not sure that this series is the culprit in any way, but 
anyway I'll try to reproduce (it happened at the end of a RHEL7.2 
installation) and let you know.  If not, it is something that already 
made its way to Linus.

Paolo
