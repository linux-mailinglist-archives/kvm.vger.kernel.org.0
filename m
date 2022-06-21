Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBC755294A
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 04:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343662AbiFUCXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 22:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241758AbiFUCXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 22:23:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D087A13F2C
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 19:23:42 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w6so4616180pfw.5
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 19:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=jCfvESmJbFrFrxib91RhFd+8YICPxN7/SvGrPipAqUU=;
        b=tEzseiRo+IjjTe0mnQmZzuLzLD1W4Yg1G89R87My3cC87tlRh0Yzam4GGUIzgC0r1w
         82ldN5+X114ZOowrREjn7dEzpTAibcfWHBH1VglPu6h8Su4nxgKsjKrwimGmcBkjUx/c
         n6KV1ryJ35HyA0Ky8EAn9Bl3cahUI6nptHesYw/Vgq87b6fcRpU4AVXx+dNlM2xDZ8Uq
         gdFXmHE9FuE76a/I5kSdyGs9IYJtbhfRDh1c0yS79WUXtDDQCeWeY9L24WmqmmvWPGGb
         XCgfu1e94ZCYoBgXOT48jxttLlyfaKSlShuUCm+YG+f6w6NlPwpDB1YphRIISRjydyo6
         CaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jCfvESmJbFrFrxib91RhFd+8YICPxN7/SvGrPipAqUU=;
        b=cdVP4Jni//rQLXScvIzOU2VnIlK6ltcpzr0TA2+EBbvsg8lvcHWLMXJGiNq3JA3/TI
         EKB7ZGZGZLvRi4DgF9Aq5hq9RFo8W+Y8qJ5FrJrvbT9mGSKLgm8NqimmLyAzUplhs98w
         REITCNpivJ00SoolC7I+7g01MD3lET+WlwDMPWD3SFd1HEev6g5aLtVBj7DFhdFRSst+
         uoqi3NjkhsVP+AMpuAULUXUAZ+ELcGmn+QMHOT2YdMeDeJ39Q3z83wr0bTHViniMa6gp
         6bVQrbpvtlkRaobFeOBgkmGvkNTMI9tEsniRWxNBBzKA2J+/99ijokUENDDGNBD0NESp
         I80g==
X-Gm-Message-State: AJIora/zgQb0Y/oKqd7o6bZeahcKYYvexGh5PzKU/GLKrSmlMKuXDrIl
        kvtu2S+OFxMdDcm3AiMvW8stCA==
X-Google-Smtp-Source: AGRyM1umRh2xAhLN3NHFMZRSraOLrzMaEsRwbcgQivpyKBaHn3oB83boV2FoRKS0rA8nWsxihzs+bg==
X-Received: by 2002:a05:6a00:198c:b0:51c:7547:58e0 with SMTP id d12-20020a056a00198c00b0051c754758e0mr27215792pfl.82.1655778222385;
        Mon, 20 Jun 2022 19:23:42 -0700 (PDT)
Received: from [10.94.57.128] ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902784200b0015edc07dcf3sm371757pln.21.2022.06.20.19.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 19:23:41 -0700 (PDT)
Message-ID: <9d5c66e6-bc27-026e-fca2-9863ec2bafbd@bytedance.com>
Date:   Tue, 21 Jun 2022 10:23:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [External] [PATCH v9 9/9] KVM: VMX: enable IPI virtualization
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        zhouyibo@bytedance.com
References: <20220419154510.11938-1-guang.zeng@intel.com>
 <cdead652-cbd6-90e4-dab8-9cb18f71a624@bytedance.com>
 <20220620105957.GA9496@gao-cwp>
From:   Shenming Lu <lushenming@bytedance.com>
In-Reply-To: <20220620105957.GA9496@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/2022 19:00, Chao Gao wrote:
> On Mon, Jun 20, 2022 at 06:02:32PM +0800, Shenming Lu wrote:
>>> +		if (enable_ipiv)
>>> +			tertiary_exec_controls_clearbit(vmx, TERTIARY_EXEC_IPI_VIRT);
>>> +	}
>>>    	vmx_update_msr_bitmap_x2apic(vcpu);
>>>    }
>>
>> Hi, just a small question here:
>>
>> It seems that we clear the TERTIARY_EXEC_IPI_VIRT bit before enabling
>> interception for APIC_ICR when deactivating APICv on some reason.
>> Is there any problem with this sequence?
> 
> Both are done before the next vCPU entry. As long as no guest code can
> run between them (APICv setting takes effect in guest), this sequence
> shouldn't have any problem.

OK. Thanks for reply,

Shenmimg
