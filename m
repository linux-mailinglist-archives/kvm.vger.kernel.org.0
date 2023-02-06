Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4903D68BCA9
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjBFMSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjBFMS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:18:27 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD6D11E83
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:18:03 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so3342803wmb.2
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 04:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lx5Ohc1IE89aa70gryDvD7lr6fDgHnr2p/EPj5EPyOU=;
        b=3VPWF04cu/QdimD3GlaH0mg4J+X+NuCR7o8pHvDUVTqXQyhcuY0kdyizW+yjhVo6/1
         GLspURgONjRD6aZUy9+r+9ZGBVmxSSYscZDxI/4Lc0XnYbE8stUX4fNl+W/W0H103tlq
         1BOX2H9YI/u+TsQLkvB6vp1NNQVNYYdim3x1tzahMjeQhT/+tl7irelkp6A90gtO1pa4
         KuLoBVMyQTb/rseog0S3aRr12rlkKZoAptxdXbTMQnw1OgkKqaiSxt/t5GJyQfe/4n/3
         gnYe3oz0LCszQf5DRC00W1lufHyismbDSLmcuEVaL9GT8eehLaTmbxNyD390JYKQ/nAv
         v1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lx5Ohc1IE89aa70gryDvD7lr6fDgHnr2p/EPj5EPyOU=;
        b=jnCRMgbcUNaMZXqQhkP++Zy5rQXFNwLnPrIVhUJuKc6y/AS1rTsTQHMMy96MqcDlsU
         scYNARsiDVymfjCu8M8uq/c2v/+2UW0XhANTkJirBheZ52PsMf/7/KKOHvhxJA122aJX
         mdoBsqIGmUcmfFacImU2oIBPdXEF6xfG1ipH9TkrjHjBJRh8DNhPgEnQxA6/yIOToaF5
         6DE59+DZm6GZ9nmESk2LoHlz/jubTl9J7yjTJ1wstF08Kddd/eMVtWYaovV/mFavdrni
         Sl4svvsfxKxotJXYi5f+y11vQzVpAAj6qalwgqFpQnuxh3WuNGss+nv5InvUx5rX5k/k
         MeQQ==
X-Gm-Message-State: AO0yUKXVnvbO3AFLFpfFEZq/MjsX0k/3YFLjYooihgCYY9dd9oOEDNUt
        h+/JuPRAunyXySL7dbto6R/4XQ==
X-Google-Smtp-Source: AK7set9HlkV3ZGPYkKQclq2QCDQpivZwgTcyVZD1/kScTrheRcsJb+knyABqk4hpGfHT0oD64lOn1w==
X-Received: by 2002:a05:600c:4fd3:b0:3df:eea8:1fe5 with SMTP id o19-20020a05600c4fd300b003dfeea81fe5mr9648629wmq.14.1675685881710;
        Mon, 06 Feb 2023 04:18:01 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:39c7:f90d:557:dc30? ([2a02:6b6a:b566:0:39c7:f90d:557:dc30])
        by smtp.gmail.com with ESMTPSA id fc13-20020a05600c524d00b003db01178b62sm17739492wmb.40.2023.02.06.04.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:18:01 -0800 (PST)
Message-ID: <ced10a5a-d5d9-ef45-a454-706fff89a672@bytedance.com>
Date:   Mon, 6 Feb 2023 12:18:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v6 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, Russ Anderson <rja@hpe.com>
Cc:     tglx@linutronix.de, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230205191734.GA6027@hpe.com>
 <3b626936ccc4d5123cb9113378bec6f77182def3.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <3b626936ccc4d5123cb9113378bec6f77182def3.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/02/2023 08:28, David Woodhouse wrote:
> On Sun, 2023-02-05 at 13:17 -0600, Russ Anderson wrote:
>>
>> Gave the v6 patchset a try on a system with 1920 logocal cpus
>> (sixteen 60 core Sapphire Rapids sockets with Hyperthreadding
>> enabled).
>>
>> Without the patchset it took 71 seconds to start all the cpus.
>> With the v6 patchset it took 14 seconds to start all the cpus,
>> a reduction of 57 seconds.  That is impressive.
>>
>> Full boot, to root login prompt, without patches takes 223 seconds.
>> This patchset reduces the full boot time by 57 seconds, a 25%
>> reduction.
> 
> Nice; thanks for testing.
> 
> Is that with just the "part1" patch series which has been posted, or
> also with the 'parallel part 2' still taking shape in the tree at
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-rc6
> 
> I believe Usama said the second phase of parallelism didn't really help
> much in terms of overall timing? Confirming that *without* all the
> debug prints would be interesting. And we can look for what still
> *could* be made parallel.

I think it would be interesting to get the numbers for such a big 
machine for 3 cases: part1, part1+reuse timer calibration and part1+part2.

Russ mentioned testing v6, so I guess the above numbers are for 
part1+reuse timer calibration.

For my machine the smpboot times were:

No patches: 700ms
part 1:100ms
part1+reuse timer calibration: 30ms
part1+part2: 30ms

Thanks,
Usama


