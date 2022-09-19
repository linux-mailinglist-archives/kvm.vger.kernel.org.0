Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE735BC37B
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 09:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiISH0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 03:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiISH0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 03:26:14 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CD31AF3B;
        Mon, 19 Sep 2022 00:26:13 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e68so27251736pfe.1;
        Mon, 19 Sep 2022 00:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hXqXe6RjT90LFOD/PAYg7ZqKCrE+b+CKvrN2/qxbWPc=;
        b=Hol1q/SA/TM1plGqmuLeVgcxKQ2264kUUm33EesYm34vxsbK7gBaYeoHckidynQvBM
         489NG8Tpa0VyqTJ3FyVO4TNK7nMlT7MW2QVVDn7kWqNJ3EnDPwrpBXQyX+zDzjZ11Xxs
         SKa00Trkt4OJfvDfZTS05sJGDLrBWt/r66Hwo1KWtnRWw4nG8q8OSEor446PidV13RqM
         gjgeRt5byHSpnBs7LP5Wr9hljNzaET+Uw/HMxPmxa3HI/5HGi3Jmog7BaIUxqUsbBys1
         z+3G25LBZLrphxKcRjGs9hHLRsInEQ61yELuW2U++XZawffT4iYeWlFvvkUClskV2ES3
         MS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hXqXe6RjT90LFOD/PAYg7ZqKCrE+b+CKvrN2/qxbWPc=;
        b=ZF5j+QxWmRf85kb4TOP5qzIqPpm5XZjiuPeRFClot3Lwdbh7Z/62eArRIYyQWWVfax
         eeBI5YdobaSgw9K+XzuHVyUfdViHEuX3iVVPRn3cHwRBvfpfCDuCn15aIblv+/VO2v3B
         h22p/J9wLGSLVhw07QdG6EHJrw3mKsuGkzyAXTGh77MtuQP8O+hXNqU/yHurEyKcGGKm
         mB0Uzgghyij/+hlDt70B3L2xl7fOr32x56mPN3IU+EmKP1Gyhzl5xXks4d3QkQyk3+Xe
         f7uYmm2hOl8rkOTRn6zs1AIVirIfinCZ4hUUTpzP8EXwGEFbZfaJY/5EwIADJja0X1lD
         edLw==
X-Gm-Message-State: ACrzQf2XHI3OWS69t0PIUuu8GIBB/r3D3umpu5Wni3C6PKRGsT7ZG816
        9dXr+9SrmzlhIb86baSC4Z8=
X-Google-Smtp-Source: AMsMyM4I1b8NQ/XCZ+Ut+hsbH8xcih23yH/JQisB8VeSGcDWkj3B0zuJfSfVjIg9Dvscd0JlXYZS6g==
X-Received: by 2002:a63:2c2:0:b0:439:4581:d2af with SMTP id 185-20020a6302c2000000b004394581d2afmr14678385pgc.497.1663572373329;
        Mon, 19 Sep 2022 00:26:13 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n17-20020a170903111100b00176ca74c58bsm3909851plh.245.2022.09.19.00.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 00:26:12 -0700 (PDT)
Message-ID: <ec0f97e9-33b7-61d8-25b8-50175544dbdd@gmail.com>
Date:   Mon, 19 Sep 2022 15:26:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v14 00/11] KVM: x86/pmu: Guest Last Branch Recording
 Enabling
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <CALMp9eRC2APJgB3Y7S4MWsTs9wom3iQycd60kM2eJg39N_L4Ag@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eRC2APJgB3Y7S4MWsTs9wom3iQycd60kM2eJg39N_L4Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/9/2022 7:42 am, Jim Mattson wrote:
> How does live migration work? I don't see any mechanism for recording
> the current LBR MSRs on suspend or restoring them on resume.

Considering that LBR is still a model specific feature, migration is less 
valuable unless
both LBR_FMT values of the migration side are the same, the compatibility check
(based on cpu models) is required (gathering dust in my to-do list);

and there is another dusty missing piece is how to ensure that vcpu can get LBR 
hardware in
vmx transition when KVM lbr event fails in host lbr event competition, the 
complexity here is
that the host and guest may have different LBR filtering options.

The good news is the Architecture LBR will add save/restore support since Paolo 
is not averse to
putting more msr's into msrs_to_save_all[], perhaps a dynamic addition mechanism 
is a prerequisite.

Please let me know what your priority preferences are for these tasks above.
