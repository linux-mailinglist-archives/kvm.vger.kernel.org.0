Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507CD2314A1
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgG1Vbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:31:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:48468 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgG1Vbr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595971905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdzINqb+VnzLPxNHZys3RQikWnBHmZ8w2QpXq7semMk=;
        b=YuT+wWxSk4vArozTs8lRprePoOfOzM0hHj/rNFBVVfLhO6d5iW/7PcqpN34b94QaMlFWUN
        SbCvGWOr+xfaPLd1DFpUniatpBvoWWQjA4SLfSd2WRkJV7g1mg04RV4N/tKXv+j3r95uB/
        3suqYAIXs6kBjbXcpYauxWtJR2LnYlQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-sRU-NNKWPfSBAorHUPBCRw-1; Tue, 28 Jul 2020 17:31:42 -0400
X-MC-Unique: sRU-NNKWPfSBAorHUPBCRw-1
Received: by mail-wr1-f69.google.com with SMTP id 89so5753245wrr.15
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zdzINqb+VnzLPxNHZys3RQikWnBHmZ8w2QpXq7semMk=;
        b=KWBS1O1pq4JOTK7/DEo6NTReJii2TuXQF9hUdS1nBCn1qOmMqltw/LZfz8Q8zqsIa3
         EZisPLMcV2Gf1zj/pdKcIDATpQE7hmZ7YRwxlP+T7yia4xx29l32sreZdUeQvddVQ8C8
         k4NZmkd/9xNKfzBXfoYEhQ2Lk+1WESpItxqxmYiNraow7i9bVzfBShybEVU3u3tetURg
         JsbGpyHMt6n9gtWRjThv7/Vwt6AZwPeaMwxmvIh6tlgOB94JTo4A3P3bxacmdKXmrdMU
         SBd3ZaAvLxwDW16BLP/T1xe1C2no8Su7aCuwr6UMpC2BqHpFleeO84d+CPdwGvvf9g+K
         tb2Q==
X-Gm-Message-State: AOAM5309iKEvugteoTC474FZaFcc9CafeV+StGCupQSpBwu2h5X9KyhS
        2J4QCQd2VtDFSvNdvFPA4Xu/OtPFIItgndjhZSkjpUKbBuIMekV+vDkauY/CGfN9kf7l2o7OO6e
        i9Et9GsRfThUa
X-Received: by 2002:a1c:7511:: with SMTP id o17mr6001833wmc.49.1595971900940;
        Tue, 28 Jul 2020 14:31:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYXn9Y1v+DPCBNKtJDAcHYSeHafuUX1DWq9FAM5Xu3HT+xog9iCikmTKM5Z4Um1tYExXc1DA==
X-Received: by 2002:a1c:7511:: with SMTP id o17mr6001748wmc.49.1595971899219;
        Tue, 28 Jul 2020 14:31:39 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id z127sm197534wme.44.2020.07.28.14.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:31:38 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] cstart64: do not assume CR4 should be zero
To:     Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200715205235.13113-1-sean.j.christopherson@intel.com>
 <A0720822-B4F0-4AB6-98A2-2C4FD1124A95@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e79b76ae-c554-6d28-7556-88b280b8f02f@redhat.com>
Date:   Tue, 28 Jul 2020 23:31:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <A0720822-B4F0-4AB6-98A2-2C4FD1124A95@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/20 23:46, Nadav Amit wrote:
>> On Jul 15, 2020, at 1:52 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>
>> Explicitly zero cr4 in prepare_64() instead of "zeroing" it in the
>> common enter_long_mode().  Clobbering cr4 in enter_long_mode() breaks
>> switch_to_5level(), which sets cr4.LA57 before calling enter_long_mode()
>> and obviously expects cr4 to be preserved.
>>
>> Fixes: d86ef58 ("cstart: do not assume CR4 starts as zero")
>> Cc: Nadav Amit <namit@vmware.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>
>> Two lines of code, two bugs.  I'm pretty sure Paolo should win some kind
>> of award. :-D
> 
> I guess it is my fault for stressing him to push the changes so I can run it
> on the AMD machine that was lended to me.
> 
> Reviewed-by: Nadav Amit <namit@vmware.com>

I can blame you for this one but not for cstart.S.  At least this made
me realize that the bus factor is a bit low.  Well, if I were really hit
by a bus I guess you guys would figure out something, but for more short
term issues I should ensure that someone else has write access to
kvm.git.  If no one volunteers, I'll ask Konstantin Ryabitsev to give
back commit access to Marcelo Tosatti for emergency cases.

Paolo

