Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C622A5AD80F
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 19:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiIERG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbiIERGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 13:06:54 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC82A4BA6A;
        Mon,  5 Sep 2022 10:06:53 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id d5so5549693wms.5;
        Mon, 05 Sep 2022 10:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=d9TAneKl/IB22ze9RSEc+xm4pxhpst3mt3s1A5vkCeA=;
        b=5bIMzqJEYi475D5LBMMSqSYZWu1Bs/zkU1jfD505MiGk4fqeB1VkGY9sdD86iLI79S
         Wpnedj9yDrJ441+76qhlXHrFFSy5gGv0ry0u9VrZFZKEkuKrMhc3WnRRf/AZ45uX/YK9
         C8h4nGFpkwemI+mP4TQ9D54VqtS1np4deg7aKNubr2chOeM8DFXeSiPpiMks9NWoMtWi
         IQC/vZ16wUmFo8OAqgSNwzUe8Z5HH//Bhzb473vl47koR+3s+i8rCOt0jeLqhjDMH8fh
         kUhVvjFFHv/pwI/b0MuG7Q24njc84kh6MSnwfZE6ZlX7HVSVBxshpItLKqg/jHrpVUkY
         T4TQ==
X-Gm-Message-State: ACgBeo3GtLCoicLLBw0VCnD7ry0sDZvGuCbNDLNme7+A6/e5Y76SNiqb
        OsVfT8PNwUQBSBPnvqgXG8E=
X-Google-Smtp-Source: AA6agR4mUT7QMGWlmzBNULt1v9DXiqnE7dEUFFbmulPE92yzI9zmusmbR48eyfmub91fdHoYvnOCqQ==
X-Received: by 2002:a1c:3584:0:b0:3a5:fb0e:102e with SMTP id c126-20020a1c3584000000b003a5fb0e102emr11618897wma.105.1662397612187;
        Mon, 05 Sep 2022 10:06:52 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c350600b003a541d893desm12386483wmq.38.2022.09.05.10.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:06:51 -0700 (PDT)
Date:   Mon, 5 Sep 2022 17:06:47 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v6 02/33] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <20220905170647.ky7rf5ypmqwxb7wx@liuwe-devbox-debian-v2>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
 <20220830133737.1539624-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830133737.1539624-3-vkuznets@redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 03:37:06PM +0200, Vitaly Kuznetsov wrote:
> Updated Hyper-V Enlightened VMCS specification lists several new
> fields for the following features:
> 
> - PerfGlobalCtrl
> - EnclsExitingBitmap
> - Tsc Scaling
> - GuestLbrCtl
> - CET
> - SSP
> 
> Update the definition.
> 
> Note, the updated spec also provides an additional CPUID feature flag,
> CPUIDD.0x4000000A.EBX BIT(0), for PerfGlobalCtrl to workaround a Windows
> 11 quirk.  Despite what the TLFS says:
> 
>   Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl
>   fields in the enlightened VMCS.
> 
> guests can safely use the fields if they are enumerated in the
> architectural VMX MSRs.  I.e. KVM-on-HyperV doesn't need to check the
> CPUID bit, but KVM-as-HyperV must ensure the bit is set if PerfGlobalCtrl
> fields are exposed to L1.
> 
> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> [sean: tweak CPUID name to make it PerfGlobalCtrl only]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
