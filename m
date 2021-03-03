Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7E132B5C8
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449373AbhCCHUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbhCCCkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 21:40:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEE4C061797;
        Tue,  2 Mar 2021 18:39:41 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h4so15192891pgf.13;
        Tue, 02 Mar 2021 18:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EGVG4WkVl5pFpBjbmr9YGkCtEq1i3vWKYOcjQG1R/v0=;
        b=aS2Uf5dAX41dzyG77xCrLK1TGmya8ecK4+YhOlzcqqsTSkEuXC56qYFBPV0qZ5AokF
         U1IZ2uNq4U6kIX9oRa42X00OpuSFbq2FjtuDXhprPoLZZer5qI2u1ucLXVEDWEJix57b
         slwzL4TMyf6hYBH2vyHO6DV7n+1ob4g5K4AnsnHsmcb5Sj58xXxhD/n7+9afq76e5GwW
         UcTNyVtZ+70xaz+a6rwbuiJExyp3ySWrDbu3ethvOT0WXZdB2VBXYp3ey9sMoIk2TzXT
         DFw0zMf4+go0l5NdnamfzDJqp1S4hKinnX01Kh3f85oojOfVluEPIwk+jkLAQipNLpmT
         2XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EGVG4WkVl5pFpBjbmr9YGkCtEq1i3vWKYOcjQG1R/v0=;
        b=cfuXUxenT2e3KCDejA/ZlO7BD3CI17rmGDbHWI3UqKYdDO63hs/rkHs2ngGIeqHrw7
         kAqxVEbZExlTeeFw7vn2VuELCmoM53HqDxKinMdKxU5j6oVRtipUMGe06f7WQAKXsQ78
         Doj46jBMRkOn/GIS6AqzLAACzMXl8KqOhVFOUlH31jXBfLyUPt6CwmWxL2Qawi54ebc6
         nbkDVQXoVHFIaE9FcaTuk2ZmPxP2FGcKzInVTul0ZeWE9e/40PGDwGQWkixr9JOiNsow
         97Go5K6NurZ2pPXXuN24Ui9rZEJ4wlpACeGjjz4ytS9V2ynziYmiSszMAKSQmyAAfHBj
         IiOg==
X-Gm-Message-State: AOAM530VxAFz+fRRLMh8UIQ9/xw2pFuq0wml7cIxH3gWF+5osJnRFROy
        u6W5fDPzuOuqAjywL8T8og==
X-Google-Smtp-Source: ABdhPJyks6SodkO5sqbqFQUQZ/9OziaBwHkURJyyyVxkHE4I9p4DH0accCxHjQEUk8hg9uGmf6yrPg==
X-Received: by 2002:a63:741:: with SMTP id 62mr1302468pgh.70.1614739180726;
        Tue, 02 Mar 2021 18:39:40 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.56])
        by smtp.gmail.com with ESMTPSA id v1sm9289197pgh.17.2021.03.02.18.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 18:39:40 -0800 (PST)
Subject: Re: [PATCH] kvm: lapic: add module parameters for
 LAPIC_TIMER_ADVANCE_ADJUST_MAX/MIN
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
References: <20210303020946.26083-1-lihaiwei.kernel@gmail.com>
Message-ID: <03239d81-df56-a6c9-c79d-c14d22f62705@gmail.com>
Date:   Wed, 3 Mar 2021 10:39:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303020946.26083-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/3/3 10:09, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> In my test environment, advance_expire_delta is frequently greater than
> the fixed LAPIC_TIMER_ADVANCE_ADJUST_MAX. And this will hinder the
> adjustment.

Supplementary details:

I have tried to backport timer related features to our production
kernel.

After completed, i found that advance_expire_delta is frequently greater
than the fixed value. It's necessary to trun the fixed to dynamically
values.

-- 
Haiwei Li
