Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70ED504A0
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 10:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfFXIdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 04:33:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35087 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbfFXIdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 04:33:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id f15so3007275wrp.2
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 01:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bnWH5ZYxHlgk6lep5hk4Qa6BJhgMEWUWAwCwWs+mOkc=;
        b=L8LYII6g2TgE6vsKX5jroLtU72tGyICpLMnV+CN7nKLOnTB6WvGnRchGm/EYlsUamR
         O7ZPojy4cYNK8lL6m/lIJsLECsV00FWtrKPn9xjMjrP5wOz00LctJJw83pgSzamObs8v
         aovznKlc5c0bZnTcDdVNqjO3UHP5hTyTc4TQi5lN0FkhwuvkSinJWPt6CqHrVz1TCmCv
         eM68pDxkMMBG0DyYBEhd5/Ifo5vLJQh2sY9CV2q9vXH+gEF6NjmzlnyubDrKtbNojr7V
         hRQTxHtlINf01cFoDQOv7o2tD+q6h4X6tjbtION3LzlOR963kBWl3N9yqFCiSXI0oWb+
         O4LQ==
X-Gm-Message-State: APjAAAWxVpYqspRxqpsJciTjEVp5CFkwd0+DxLrJFmm+mQIExeTjHJy5
        qdyn+7DP23eyDzASTan5sDDDrGUExVo=
X-Google-Smtp-Source: APXvYqzvQga6R/hMu6SQdyZltSZSj0H1hwlCMupwuQ3CzWkY4X6amO1rNwFKryTvHOYQ/5B3klPoLA==
X-Received: by 2002:adf:e705:: with SMTP id c5mr81080226wrm.270.1561365219275;
        Mon, 24 Jun 2019 01:33:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id j32sm24751894wrj.43.2019.06.24.01.33.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 01:33:38 -0700 (PDT)
Subject: Re: [PATCH RFC] kvm: x86: Expose AVX512_BF16 feature to guest
To:     Jing Liu <jing2.liu@linux.intel.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <1561029712-11848-1-git-send-email-jing2.liu@linux.intel.com>
 <1561029712-11848-2-git-send-email-jing2.liu@linux.intel.com>
 <fd861e94-3ea5-3976-9855-05375f869f00@redhat.com>
 <384bc07d-6105-d380-cd44-4518870c15f1@linux.intel.com>
 <fb749626-1d9e-138f-c673-14b52fe7170c@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7d304ae7-73c0-d2a9-cd3e-975941a91266@redhat.com>
Date:   Mon, 24 Jun 2019 10:33:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <fb749626-1d9e-138f-c673-14b52fe7170c@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/19 05:10, Jing Liu wrote:
>> What do you think about @index in current function? Does it mean, we
>> need put cpuid from index to max subleaf to @entry[i]? If so, the logic
>> seems as follows,
>>
>> if (index == 0) {
>>      // Put subleaf 0 into @entry
>>      // Put subleaf 1 into @entry[1]
>> } else if (index < entry->eax) {
>>      // Put subleaf 1 into @entry
>> } else {
>>      // Put all zero into @entry
>> }
>>
>> But this seems not identical with other cases, for current caller
>> function. Or we can simply ignore @index in 0x07 and just put all
>> possible subleaf info back?

There are indeed quite some cleanups to be made there.  Let me post a
series as soon as possible, and you can base your work on it.

Paolo
