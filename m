Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C541EB42C
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 06:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgFBEPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 00:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBEPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 00:15:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4682C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 21:15:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so3453528pfg.2
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 21:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PXGJ4gt5oyH1UgM0SNXfgnxueAMm6B3WnIoe3BdHTxk=;
        b=y2gESXYMO/iSq31PLf7FlD0APM8iB3f1Jx2LNbpvW5OoT1NmiTiBnMqjcY7ePtTwPU
         lEu80E9sphH65CGomcMaCZiOqQhmjVsJaNBmzY3M5p65w7rljbjUMsLfxLPuXhur00ce
         1qSPgG42ZpxSMY7k7qBVoFOf8M0qcUZ0xONET+la7mtID4gNfj4CXV4Py04/bBqRZBwy
         7hv0YpB78hppAJn0H0qM0QWhNm6uAJ01gYLot0xpp4IO701XGfNqNvh3wLlg5tsdjpwT
         j4tqNPLVHfMCM8M4TnWgETRFimEbNZzFVWnNBXH0ELeO7PSkWIC9l0ZfLSCXQYqjlncX
         ZkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXGJ4gt5oyH1UgM0SNXfgnxueAMm6B3WnIoe3BdHTxk=;
        b=Sl6QAaxcXQCfjv/fkvuQOLPuYXUiYpmPqZWQnYzqluFEduF30k9RzQEVYtp3DaYuPL
         G4eq6tcLiRJojjJbOTpilZkOnofZQuPb7C+lcYyuzeSD9kiLS15Ac1rXSeUQPKWUitJs
         gSnpPTzSeyZKfnolba/ZjoyV2+Whr8CDJFXiFJ3wWLQQ42Xw0i6Y3WF229cKQsqk9zMx
         ynFiy/xqEoaD7fFto4XjWUFvxawazmvWSYIU/vIj2pAsW4ezBfMaLj7+FLawuxHjQxns
         ln19qBvjAxsrU4oiXPKG6cCVv05CscVdNMIigDMp9OhAvtBii2M1pZk2Wwu0rN/vEKbd
         5EAA==
X-Gm-Message-State: AOAM530t0YcN5WoiH1eVjUg8iElgbZ2XT68tLkaadKghQ25GJ32C9/V/
        7ipuZMOAz7PLeJA+L8H3+vQZ7A==
X-Google-Smtp-Source: ABdhPJxLDfCnVA3/aAfcMXPKTFGbRAmuXfL/fQBrCvRzdKwgJzvl1sYbzaUp265Dyq7tZTS3wgHEyQ==
X-Received: by 2002:a63:c846:: with SMTP id l6mr21787298pgi.197.1591071344366;
        Mon, 01 Jun 2020 21:15:44 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id c8sm877062pjn.16.2020.06.01.21.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 21:15:43 -0700 (PDT)
Subject: Re: [RFC v2 16/18] guest memory protection: Add Error ** to
 GuestMemoryProtection::kvm_init
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-17-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <4bba205c-00a7-d642-800c-a5ed8469836c@linaro.org>
Date:   Mon, 1 Jun 2020 21:15:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-17-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:43 PM, David Gibson wrote:
> This allows failures to be reported richly and idiomatically.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c                    |  4 +++-
>  include/exec/guest-memory-protection.h |  2 +-
>  target/i386/sev.c                      | 31 +++++++++++++-------------
>  3 files changed, 19 insertions(+), 18 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

