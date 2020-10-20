Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE7293665
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 10:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgJTIHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 04:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729501AbgJTIHb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 04:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603181250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9X9z7bcSkIflMn/EuSDjY+5PXLgWKnYQvzQsm5FKNI4=;
        b=a1bg8ULyM7eyVVdxPLeH4veCsteP3ZUsTPPWVoEImBYq1YeH1fE6CUI+TsAL+DYrcFGX+d
        sPJtE+nDNwcdlrn2CJ87naQZ/BcTDaBELB/ARJclQkYcOPHvxYqPIZoo+ocpQsQ8AXX3h5
        eco1cerXlwTrc9gRGMA8Ye4UW1mLgwk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-HOxjV7vmMJe8FqNM-a-zvA-1; Tue, 20 Oct 2020 04:07:28 -0400
X-MC-Unique: HOxjV7vmMJe8FqNM-a-zvA-1
Received: by mail-wr1-f70.google.com with SMTP id 33so467008wrf.22
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 01:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9X9z7bcSkIflMn/EuSDjY+5PXLgWKnYQvzQsm5FKNI4=;
        b=j/julW1TZpahLklZfwL5FCkrKb0lgVxBjqbksnyGbrbqkEEFfuUeN3Bo9ahoGuK2I+
         LGjneRzXJaLrndhamtq5enbx2rLuljwfZCAhSR150Ps+VWotQST0QYNnm/o9wwL0xDRs
         O8Sq+YTa4qAqNmnv/CeoKQdWzZsu0xE5/HvE08J1dQT4m5XflUgESMi2jcJvsx+aNt/w
         OnN0e/jw3hQbOFp9wcs6/KslszPtf+b4mTc3kdBGBsyewgzxO8EL9jgdm9e7BXhhSAJe
         Qw7iadAe2y2A0d8QCDIAwOxnSslAWxNb7LOKuM94ZWIIb9xgNo4plQ+0trd0Nn7oZVOd
         d85Q==
X-Gm-Message-State: AOAM532QVPmryyZ8wm5E+WikOBR3BP/BGjpNodHfYrW3UOvymuA5e4g6
        U9c+yj79u/MmDdWG6U5mKD+Q86sJbAyekMotIIeYRRg52aCO/kXyUWd3VTKVgdp1bSTW8otTDXX
        DiYU4c2Qa7Zl9
X-Received: by 2002:a5d:6a0d:: with SMTP id m13mr1970783wru.161.1603181247379;
        Tue, 20 Oct 2020 01:07:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNRdNCmWfia+V+FyupuFLmwfwLBKlDsbsy04oihernE2WtCItAguN6D52h+xDVSr+M69is3Q==
X-Received: by 2002:a5d:6a0d:: with SMTP id m13mr1970760wru.161.1603181247137;
        Tue, 20 Oct 2020 01:07:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d3sm1944911wrb.66.2020.10.20.01.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 01:07:26 -0700 (PDT)
Subject: Re: [PATCH v2 00/20] Introduce the TDP MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <f19b7f9c-ff73-c2d2-19f9-173dc8a673c3@redhat.com>
 <CANgfPd9CpYt9bVNXWbB+2VTrndfLBezqPauDo2-n8UdKDsrzpA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b07db4bf-860c-57cb-6a1d-b5a151c28c9b@redhat.com>
Date:   Tue, 20 Oct 2020 10:07:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd9CpYt9bVNXWbB+2VTrndfLBezqPauDo2-n8UdKDsrzpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/20 20:15, Ben Gardon wrote:
> When getting the dirty log, we
> follow the following steps:
> 1. Atomically get and clear an unsigned long of the dirty bitmap
> 2. For each GFN in the range of pages covered by the unsigned long mask:
>     3. Clear the dirty or writable bit on the SPTE
> 4. Copy the mask of dirty pages to be returned to userspace
> 
> If we mark the page as dirty in the dirty bitmap in step 3, we'll
> report the page as dirty twice - once in this dirty log call, and
> again in the next one. This can lead to unexpected behavior:
> 1. Pause all vCPUs
> 2. Get the dirty log <--- Returns all pages dirtied before the vCPUs were paused
> 3. Get the dirty log again <--- Unexpectedly returns a non-zero number
> of dirty pages even though no pages were actually dirtied

Got it, that might also fail the dirty_log_test.  Thanks!

Paolo

