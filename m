Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2698B7A004C
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbjINJiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbjINJiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:20 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642571BF8;
        Thu, 14 Sep 2023 02:38:16 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4cbso796311a12.1;
        Thu, 14 Sep 2023 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694684295; x=1695289095; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI015GOj12vNEvonbObjn/H9PpmmXSmK6cP4LNTtaEE=;
        b=P5QnQQwt0TpNhO49BTd5ed8S4AdmK+1+JpPpIrkaPPfJvOFcvJsRZB6UNyBlCld8D7
         E+rVJKlizJm9t4s74uO/TXj+eIOxHwJxV1D7LXCVnnV+XKzEso4ctHMzb2VNQMArQXDS
         S8TlEHGtCPxQqf7Ku/Q/CeXi12hMQP5NUrZG4tvFDzSseAZ3g8geDvCavDTMNJXB29HM
         /f1kMC2d9ZpqjcquKj/vi9Aua57EKvsEM3TNv8Qmf/tGwb1VsyaCXsKDgo4f5p42gGb+
         gAbykogd3ev9IhGcnZGZCaKSupOCmo2lSJx4BCD6rFr81byIxXOQt1tS2I0wLJ2JJY8d
         5wcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694684295; x=1695289095;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZI015GOj12vNEvonbObjn/H9PpmmXSmK6cP4LNTtaEE=;
        b=DYoToSmT0DNf2LV/BM5pp7PiRD7ulVNSd5nlpuagTlPtm9ihkYDamF6flUDY2tT5JR
         EfpsxvxNsMxGbi4r4qe7Pg9XUtWegQs7mn9fSgsUy7osHqZHgrrCLfsKPchySfIFuYZN
         o/P8cFZPMJ+c6ls3WSGbWFSb7KzRosrk8Fzbj0WraS7QhfkYizBIOn6EOfqeppM0T4iG
         0ChadbL8tOQKON2r0zJxrqpyU1jSjf0BWNkkT2EkKY4aau86rjFlT/li7aR7qqSfF1AO
         hjUg7j/7kNd4+qRyvOr4/0UCsAhti7+8+uQDhSOBSp3ZB88CA1IvNk0QBVvn3dRYY+3W
         Pnhg==
X-Gm-Message-State: AOJu0YxtrlLFRO7W3VybdfW9AEVxCB8sT45JWgCpNNBEzwOWMyS0soP8
        XW6fWGcCxu2NozpIKglSa44=
X-Google-Smtp-Source: AGHT+IE2yntHCjuRW0J/1gvduFNdizLt3EbUeYgeUjfxfagC/CW9808YAw4zmESmya8e612cBs8d0A==
X-Received: by 2002:a05:6402:5145:b0:525:7234:52b7 with SMTP id n5-20020a056402514500b00525723452b7mr4126906edd.19.1694684294745;
        Thu, 14 Sep 2023 02:38:14 -0700 (PDT)
Received: from [192.168.6.126] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id r5-20020aa7cfc5000000b0052a3ad836basm680351edy.41.2023.09.14.02.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 02:38:13 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <d28de5c6-27ff-5ced-95dc-575325e71598@xen.org>
Date:   Thu, 14 Sep 2023 11:38:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 5/8] KVM: pfncache: allow a cache to be activated with a
 fixed (userspace) HVA
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230914084946.200043-1-paul@xen.org>
 <20230914084946.200043-6-paul@xen.org>
 <7c023cb88c5f13e70b53ac695a7b45213c4f97a3.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <7c023cb88c5f13e70b53ac695a7b45213c4f97a3.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 10:29, David Woodhouse wrote:
> On Thu, 2023-09-14 at 08:49 +0000, Paul Durrant wrote:
>>
>>   int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
>>   {
>> -       return __kvm_gpc_refresh(gpc, gpc->gpa, len);
>> +       return __kvm_gpc_refresh(gpc, gpc->addr, len, gpc->addr_is_gpa);
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
> 
> I think I have a slight preference for leaving kvm_gpc_refresh()
> working on a GPA unconditionally, thus calling __kvm_gpc_refresh() with
> the final argument set to true.
> 
> Introduce another one-line wrapper kvm_gpc_refresh_hva() for the false
> case. And perhaps BUG_ON() calling the 'wrong' refresh function?

Hmm. That makes life harder for the code messing with the vcpu_info. I 
would need to know which cache it was looking at, because it could be 
the vcpu_info cache or shinfo cache, and if it's the shinfo cache it 
would need to know how it was activated.

   Paul

