Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C92420D763
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 22:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgF2T31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:29:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45946 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726573AbgF2T3X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 15:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593458962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EEwFUFQry+udhV8DYfqznHkFV9vm6Jnnli5x5VQ2DrA=;
        b=YjhXO+tYbnoK1AIqVKIefosdAXaieZW/8WcukjTz376bfkDrOGA8I6zYnzRYg+5gFfaTNQ
        DdwSkCCB9W3BFvS/PYSsVDMpTyTe191cEc/Zb24f73uwWJHd3dJoImQCvbLX2jwWKRm4Ys
        JtjhpVi80eTd2GtXrHKokxIIuXpNMSA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-j4cw0umNOkqz2kRkjgZmqA-1; Mon, 29 Jun 2020 11:27:46 -0400
X-MC-Unique: j4cw0umNOkqz2kRkjgZmqA-1
Received: by mail-wr1-f70.google.com with SMTP id b14so16761984wrp.0
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 08:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EEwFUFQry+udhV8DYfqznHkFV9vm6Jnnli5x5VQ2DrA=;
        b=i6IN6t2GLiScVwmNdlDo9s9+eFG4MxORt8prpiJsPepu4ruQtSjPo6WuMxfldc5Kid
         WS20pYV0r+mzxSBHMLrR4GmDGxcVZFArKKcEhdBpJs7m0O/wwLlFrFVrPGxhebSKRoY0
         zfJueYSHDtCUrVm4sTuSfklpFbSvQE3H0L//14NUCi074AJqIIIe9yN3Y31p19DpBOkE
         wdNFFHnwW8AS9OeMLs4s3+qNLr7l1ryPrfShABhOXNTze6lrHIG/Uo7fKLVmF7KWqmex
         ETmvMUNzgvQV4vDBIfGB+l0r1fG2rr+OMKn1HmfHXTma+7RG6JY1F5Gc5V7Z3zrz/7+0
         K6Mw==
X-Gm-Message-State: AOAM531L+vXeeQICKZhUbBj166nd0PewHWgs9tEpvT1uy7cyZ0LQMhin
        c7hRAoTdrctb3y79jTBmb8uKuEVWmhRdf7K3fetwjpb3CmV+3nI1M3u22rMsO4eIIdHuhKJXrV6
        SziyoTrWNWmLy
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr17129770wrw.405.1593444464966;
        Mon, 29 Jun 2020 08:27:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqMIsxMaRv7VRjWitk9raB65kFN9qKHn/BDrxF6Rgmqq5Yi1S0dDYjYRd/aggXszuLvxDK6w==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr17129760wrw.405.1593444464805;
        Mon, 29 Jun 2020 08:27:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b0e5:c632:a580:8b9a? ([2001:b07:6468:f312:b0e5:c632:a580:8b9a])
        by smtp.gmail.com with ESMTPSA id z132sm156976wmb.21.2020.06.29.08.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 08:27:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: fix failures on 32-bit due to
 wrong masks
To:     Nadav Amit <namit@vmware.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200619193909.18949-1-namit@vmware.com>
 <7C9B3448-6547-4813-AD40-109E2D413D51@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3cf647ed-8c44-6c9c-065b-e1b2e8130b6b@redhat.com>
Date:   Mon, 29 Jun 2020 17:27:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7C9B3448-6547-4813-AD40-109E2D413D51@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 18:33, Nadav Amit wrote:
>> On Jun 19, 2020, at 12:39 PM, Nadav Amit <namit@vmware.com> wrote:
>>
>> Some mask computation are using long constants instead of long long
>> constants, which causes test failures on x86-32.
>>
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>>
> 
> Paolo,
> 
> As you were so quick to respond to the other patches that I recent sent
> (despite some defections), I presume you missed this one.
> 
> (Otherwise, no rush).
> 

Yes, indeed.  Applied now, thanks!

Paolo

