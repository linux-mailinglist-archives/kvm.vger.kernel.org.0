Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09381AC80D
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441775AbgDPPC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:02:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40709 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441724AbgDPNxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5Kvo8iqImptqYWsZSVRrcAXyDBLn+NV1FJvmlGAZQs=;
        b=RoTJFRbR4rzaOwNX7LcSs9elegXgI7fBsqdwi96HECy8futjYinQItzUlaftvuAqO0c7Yb
        jwQKfnWxXZxY4S1NGcuwObEHaIOcri0paPu1hRmE5RL6nVFuXREyfZvkeVOh9qL6cofR/c
        t3/UBI4k02MNHwYgJeIEBCfOdW1IRlU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-A3KAQLGZPS6-NcaHNtWp6A-1; Thu, 16 Apr 2020 09:53:39 -0400
X-MC-Unique: A3KAQLGZPS6-NcaHNtWp6A-1
Received: by mail-wm1-f72.google.com with SMTP id v185so473816wmg.0
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:53:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l5Kvo8iqImptqYWsZSVRrcAXyDBLn+NV1FJvmlGAZQs=;
        b=DmXN1sGdgvmzXArnLdv38+SWH2tc15XxpwD1JuP+XTyqzBMR96E6U1eEssDjKGg2im
         pLfRTeBSycqYnPiOQ4ioLQOkP9Wixg/+qrbc7ruXM04dSNlaZXlRAFSRd7KAXFcifQ6Z
         n2gGqSQvQHED2Hk4phRzJNA7O7HO8WFXtPeaV4Dvu3r+YUQ0WiV2b1MJp/ia7dS1c5uQ
         WGVebFq21gZ6GDDq9NTmFxAlON7a0uoQ2d25GsEsA2GQRDDbQqWQxZLnoykcz7W+iOwj
         Sb0t6g6WVTJkskX2bBOZ0g8eeBzLMKYE/+6mqA//4+hSFeTyQsjtoPiODIJRzwiln/z7
         hf3Q==
X-Gm-Message-State: AGi0PuadkNe76sDZRlTHd11Me2ewUOQuJt3AAOmtJKuKVbU+M/nIpXUQ
        JAIYk/TLTuEfLvpo75u6Vy4YcB4KxsPIs1uq7CDudRATucNZwE4Ewz76xj0GXpC9K9jq+gIWb0s
        I7JkDl6W8qreR
X-Received: by 2002:a1c:41d7:: with SMTP id o206mr5041255wma.89.1587045218353;
        Thu, 16 Apr 2020 06:53:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypJz8z7BCZnr8VscT/Dzs37ZSpW6T2prR2o4U8uyDX4us/2PqqegrZdIYt2ZRQvbdMEU26XesA==
X-Received: by 2002:a1c:41d7:: with SMTP id o206mr5041239wma.89.1587045218126;
        Thu, 16 Apr 2020 06:53:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id f23sm3585008wml.4.2020.04.16.06.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 06:53:37 -0700 (PDT)
Subject: Re: [PATCH 1/1] selftests: kvm: Add overlapped memory regions test
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        kvm@vger.kernel.org
Cc:     drjones@redhat.com, sean.j.christopherson@intel.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200415204505.10021-1-wainersm@redhat.com>
 <20200415204505.10021-2-wainersm@redhat.com>
 <455a01b6-506b-3c16-7ad8-327ad63292e9@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1d05b77b-1e8b-2dfd-cbc9-5b09b685b630@redhat.com>
Date:   Thu, 16 Apr 2020 15:53:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <455a01b6-506b-3c16-7ad8-327ad63292e9@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 01:57, Krish Sadhukhan wrote:
> 
>> Add the test_overlap_memory_regions() test case in
>> set_memory_region_test. This should check that overlapping
>> memory regions on the guest physical address cannot be added.
> 
> 
> I think the commit header and the body need some improvement. For example,
> 
>         Header: Test that overlapping guest memory regions can not be added
> 
>         Body:  Enhance the existing tests in set_memory_region_test.c so
> that it tests overlapping guest
> 
>                     memory regions. The new test verifies that adding
> overlapping guest memory regions fails.

I like Wainer's header and your body. :)

Paolo

