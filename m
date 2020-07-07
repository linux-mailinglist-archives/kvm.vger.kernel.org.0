Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDCE216A53
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 12:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGGKcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 06:32:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28744 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726745AbgGGKcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 06:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594117957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QzQG4GAfpdG9+THFocXk9oynFrUbwjIlXN/HpMIoLZQ=;
        b=WECtWAC6QzqdJM/n+JGbPxNBLU36dr1msPcC5wD5UjUSwn7dW3LM0ZJmMVW6YQe4S21qi6
        wDjvoVuGYaAReFbiyzy99Zy4/IVNL2llyhO6uJbFAzcZAm9iC3xtfh5YNSa+V4c1umnza0
        eY3pkUjqvSV4RQOdLW6tiI7+ElVw5hs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-Vpss0FptOvedHM_if_a8xQ-1; Tue, 07 Jul 2020 06:32:35 -0400
X-MC-Unique: Vpss0FptOvedHM_if_a8xQ-1
Received: by mail-wm1-f71.google.com with SMTP id v11so33448252wmb.1
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 03:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QzQG4GAfpdG9+THFocXk9oynFrUbwjIlXN/HpMIoLZQ=;
        b=DXJPZjlwvhMsT5CFetVxVdqjHfzkXCCHeq/USiPcfXggxkBnz8rzarE58l7or3r4xd
         ogPv8roL6D5ghXb0EvawhPCdRUSeIIBT4NYZQ49XIXbsS0BBctg3axWlQJ2VhTaj5zC/
         ArYP9TrTsRixwx/lDZAKUI0z+P0zJPTFcpF4Xv5CHtdIlCuNInq/fz+NcOwShA5HIuU+
         QjoQ0qRNw7x+SsHgP41ZoN3zxxaCXKBAm4SNXIfclPeaaKdA2CtCy7vj66bh5FkGs6X4
         suGwrXaUfhkJElhIDDHjTEN2aq4s/9TVT6qDm7MZI59HnbCpVHzeEMK12LPhwHazYwM7
         10kg==
X-Gm-Message-State: AOAM5321yju3nwELC0j9+dJXimC2mmGO+zZBC3VqRkfuInrz+APkqEE8
        8C2FVWA/kV1eFV/DQc91vrUm5HE4XyY7OLxpa7Dv/K1jGsrXfQ7X7hx0L0Q+AZzjrmZIie43gKn
        F0BfQAqA+Oaz4
X-Received: by 2002:adf:e60a:: with SMTP id p10mr50899761wrm.181.1594117954702;
        Tue, 07 Jul 2020 03:32:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHUziBZrXgrZXUm3s79SsIkzbp7oKenlRl+tq+mvfQ4ZngBqvQ6FGimZnn11N9AIAGJZs7uQ==
X-Received: by 2002:adf:e60a:: with SMTP id p10mr50899748wrm.181.1594117954525;
        Tue, 07 Jul 2020 03:32:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e95f:9718:ec18:4c46? ([2001:b07:6468:f312:e95f:9718:ec18:4c46])
        by smtp.gmail.com with ESMTPSA id b10sm439397wmj.30.2020.07.07.03.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 03:32:34 -0700 (PDT)
Subject: Re: [PATCH 0/3 v3] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
 <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
 <b2276167-0bda-0b31-85c0-63a3a0b789bd@redhat.com>
 <4b0fd4e7-465a-428f-c906-ddf0ad367cbb@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <866d6456-314b-efbb-e46a-56e660c1c211@redhat.com>
Date:   Tue, 7 Jul 2020 12:32:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4b0fd4e7-465a-428f-c906-ddf0ad367cbb@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 02:34, Krish Sadhukhan wrote:
>>
> 
> Sorry, Paolo, I got bit lost here :-). IIRC, you had two comments on
> this set:
> 
>     1. kvm_valid_cr4() should be used for checking the reserved bits in
> guest CR4
> 
>     2. LMA shouldn't be checked via guest state
> 
> v3 has addressd your first suggestion by caching CR4 reserved bits in
> kvm_update_cpuid() and then using kvm_valid_cr4() in nested_vmcb_checks().
> 
> As for your second suggestion, v3 uses is_long_mode() which uses
> vcpu->arch.efer for checking long mode.
> 
> I will send out a rebased version.
> 
> Is there anything I missed ?

Maybe Sean's comment here: https://patchwork.kernel.org/patch/11550707/

Paolo

