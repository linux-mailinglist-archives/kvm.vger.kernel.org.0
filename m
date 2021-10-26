Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9C843B6AB
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhJZQRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:17:15 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:2847 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhJZQRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 12:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635264891; x=1666800891;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yu2JGpRI50QclwlQt5vTw9YKo0uOxgzPyV2504nzGjg=;
  b=oxnqQTGSaQz1DvX8z2buvgqD2daMS9gAfpmG1Nq6KmHWUCG70XAfCaqK
   yxRKdcmlsewuqTK/vr55HeEIDyMMa0gIWnyLb7hF5anoRjBGEachfOFAT
   S9O4SY+dAfEO4MDgZQJqgGMOGIvlrxwWrKgi+CR0eSFA1OqRiRCWV/IL8
   4=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 26 Oct 2021 09:14:51 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 09:14:51 -0700
Received: from [10.110.83.137] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Tue, 26 Oct 2021
 09:14:49 -0700
Subject: Re: [PATCH] kvm: Avoid shadowing a local in search_memslots()
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211026151310.42728-1-quic_qiancai@quicinc.com>
 <YXgib3l+sSwy8Sje@google.com>
From:   Qian Cai <quic_qiancai@quicinc.com>
Message-ID: <60d32a0d-9c91-8cc5-99bd-7c7a9449f7c1@quicinc.com>
Date:   Tue, 26 Oct 2021 12:14:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXgib3l+sSwy8Sje@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/26/21 11:44 AM, Sean Christopherson wrote:
> Maybe "pivot"?  Or just "tmp"?  I also vote to hoist the declaration out of the
> loop precisely to avoid potential shadows, and to also associate the variable
> with the "start" and "end" variables, e.g.

Actually, I am a bit more prefer to keep the declaration inside the loop
as it makes the declaration and assignment closer to make it easier to
understand the code. It should be relatively trivial to avoid potential
shadows in the future. It would be interesting to see what Paolo would say.
