Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8736D454D2F
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 19:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240140AbhKQSa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 13:30:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240195AbhKQSaO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 13:30:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637173635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muja5Zqc4exP8/ZNpkPsxqcHPiMkorOYQ6WQyXUYa38=;
        b=e+VRBGv3KFH+xZ3sRPiO/AOWtvEMN2/0BSKzb3X3v7EZU18lSnSAMurozf14Pkr6Qkkojs
        ndkkp8MxKwet2sqR+vxNZDFW36/UXYTolFyza5ReHcW0h6NdVHsyybi98HvBGkF80Zl1oH
        UsHG70SbUpfFUYML5dHb6x636hmLPk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-suO45-XKOS2CFKtvC8PVrQ-1; Wed, 17 Nov 2021 13:27:13 -0500
X-MC-Unique: suO45-XKOS2CFKtvC8PVrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D7B08799E0;
        Wed, 17 Nov 2021 18:27:12 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E81B5F4ED;
        Wed, 17 Nov 2021 18:27:11 +0000 (UTC)
Message-ID: <cbcce032-abfb-7fdc-74bb-0f4a29010c30@redhat.com>
Date:   Wed, 17 Nov 2021 19:27:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/4] KVM: SEV: Do COPY_ENC_CONTEXT_FROM with both VMs
 locked
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
References: <20211117163809.1441845-1-pbonzini@redhat.com>
 <20211117163809.1441845-5-pbonzini@redhat.com>
 <CAMkAt6odbAGZ-LgK7yefnNRgoAAs3ekvR2_sZpjTiv_6mfwRKg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6odbAGZ-LgK7yefnNRgoAAs3ekvR2_sZpjTiv_6mfwRKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 18:46, Peter Gonda wrote:
>> +       if (dst_kvm == src_kvm)
>> +               return -EINVAL;
>> +
> Worth adding a migrate/mirror from self fails tests in
> test_sev_(migrate|mirror)_parameters()? I guess it's already covered
> by "the source cannot be SEV enabled" test cases.
> 

It was covered by the locking test (which does not check i != j). 
There's no equivalent for the operation of creating a mirror VM, I can 
add it in v2.

Paolo

