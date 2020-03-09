Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2496617E682
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 19:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCISL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 14:11:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35619 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgCISL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 14:11:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id r7so12481194wro.2;
        Mon, 09 Mar 2020 11:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zNpV6O5ivA3Si8ar1S1KuJt1ygXwnM2oG0rkigXm7x4=;
        b=JBRI00/uh/ses/SeUVzY3vSX8ROznzWZP4qPKV7MZj4CQI49MPIFIdWxymhBZNf25G
         U5ABL2tqMu5q6D4+VRuzsw3xJ3Zk78Hz32N4PO4mq8QicxYRnKldVHd4Bv2EWtuHElIm
         D4zJLQfi6Z0pr1ZUm3ATRftoOKcTGy05fA4GjXtkGq86+VLjW195R8zrexLTKdDm2LzU
         V0hb40PTXmizWfvwIbPlfbQyR9t1g83B8fSATcvUJ1Pw4A5ipW77owKqGYQqnBb+BX8r
         pnv8tqwqMU3Enn71hitKJBfh/4W/pRuQlJCyiqNKMURDn7HSQk2JIIhjA9sPkW2cwt7o
         nlMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zNpV6O5ivA3Si8ar1S1KuJt1ygXwnM2oG0rkigXm7x4=;
        b=K4MHLUQOyFj/mVN/SszBwnY34SLs2lDn1pbfyBS4fmJwFPV4URtXePsQJO6SY66gX9
         QIykdbhRygv554fOM6EX+6Xql9HTMwP7Qpw5rXs3WyKIwLE+9+MKHGX9/M6K0ehhBUAx
         J/vIXpSszhHjZhUxvu0s7V+bil9qo3Yd9Vt5DZqFkySudLGhxaw5kIgpC1L1YkOkWo20
         zbyGPH0DPLR6v8WYU73IFz3DE2yzDEFC7C7Ebu0mpNgLn7sfv60ZYjWiD7RU1jeAuWx+
         inUX2sxVX4nNm+tYFa0YtuUdUtJ4bXWaTNm/hxF361iJqgpbUpE4MtRGoHsPMW0XaJF0
         qVxQ==
X-Gm-Message-State: ANhLgQ0OFBv7Jfl04VNmOQQwk42xRzIgWzvwxnYEpOww6LkIiPpC5Hsb
        UnSeXwoY5YWsmeUDWLvHbT0=
X-Google-Smtp-Source: ADFU+vscDulKO189yzGeCSJUrEBXThXgggVympv7I+OCNkEg2OD5wmtVBdAaUuoyClA2Y7GV3auAZA==
X-Received: by 2002:adf:c40e:: with SMTP id v14mr4488963wrf.408.1583777487640;
        Mon, 09 Mar 2020 11:11:27 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id k2sm31501062wrn.57.2020.03.09.11.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 11:11:26 -0700 (PDT)
Date:   Mon, 9 Mar 2020 20:11:25 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86/kvm/hyper-v: Explicitly align hcall param for
 kvm_hyperv_exit
Message-ID: <20200309181125.GA3755153@jondnuc>
References: <20200306163909.1020369-1-arilou@gmail.com>
 <20200306163909.1020369-2-arilou@gmail.com>
 <87k13tcxrm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87k13tcxrm.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/2020, Vitaly Kuznetsov wrote:
>Jon Doron <arilou@gmail.com> writes:
>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  include/uapi/linux/kvm.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4b95f9a31a2f..24b7c48ccc6f 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -197,6 +197,7 @@ struct kvm_hyperv_exit {
>>  			__u64 msg_page;
>>  		} synic;
>>  		struct {
>> +			__u32 pad;
>>  			__u64 input;
>>  			__u64 result;
>>  			__u64 params[2];
>
>This doesn't seem to be correct, __u64 get aligned at 8 byte boundary so
>implicitly you now (pre-patch) have the following:
>
>struct kvm_hyperv_exit {
>	__u32 type;
>        __u32 pad1;
>	union {
>		struct {
>			__u32 msr;
>                        __u32 pad2;
>			__u64 control;
>			__u64 evt_page;
>			__u64 msg_page;
>		} synic;
>		struct {
>			__u64 input;
>			__u64 result;
>			__u64 params[2];
>		} hcall;
>	} u;
>};
>
>and the suggestion is only to make it explicit. Adding something before
>'input' will actually break ABI.
>
>-- 
>Vitaly
>

Bah sorry guys :( not sure why this too so many iterations... will fix 
it right in next version.
