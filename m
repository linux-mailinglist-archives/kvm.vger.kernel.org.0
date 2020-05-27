Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9661E4979
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390879AbgE0QLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:11:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45690 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389689AbgE0QLU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 12:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590595879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eT5Xu5kIXMyMszPnZ6Nrn2fPPIp8gis023GPtPf71Sk=;
        b=dGArioqRlPQcHZQ6B+Et5A6eTtuPXnUXIrpDreC9OKy09KKD3iOqiO+nH5cI0bNxCV+1dp
        hrb1IffOAkzBx1IViwfbWOiJ9oKVvZy9EuttHxPwXT7vmx9J/cNQvs2u9PllvygWVxtd9f
        lP0C63dRkVjRz/LmDInyKno8vbAMq20=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-v8gx2FbiPAenIt2wsILtjw-1; Wed, 27 May 2020 12:11:17 -0400
X-MC-Unique: v8gx2FbiPAenIt2wsILtjw-1
Received: by mail-wm1-f71.google.com with SMTP id p24so994098wmc.1
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 09:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eT5Xu5kIXMyMszPnZ6Nrn2fPPIp8gis023GPtPf71Sk=;
        b=MfZgEbTo75wYGsL+/5+GjRahWWPHY9ZJHDiVctTrGAisc2bDybu1zYc6wsYKU3++UG
         ljx0iarda837SO5VTe7Ou1UgUEiuRNjPlQ4KYiK9J95t5q90VLx6WEdBMosT7GdMjSOu
         gtiusAOhDDwpzVoEWzzU6sRWteQkNlm56tNLrtmxGHlKH+7serUCowQ+3aBY+IqFU4AZ
         2mWOOV5dQGcbGA2Z82/5tbPKl47FOnItCPUk7dy+yl7r7n5PUyjsLHk4z4wp8LHynkdr
         l4rquZB+Z8LIY8fkc2BBAbG7xrNy3JZzUGU9GPN5hL/UD+oInBNO7B5hw7GiCC6Xve2M
         NyMA==
X-Gm-Message-State: AOAM532ONApgfMmylgPNF1XtdOG7KbIadXZ1rswUR7tR462NFbe05Ozh
        7JEoL52kUXTex4NusPUR+hco7n8tz2oNl1qWi8XgWqpsPiNXi5oMFScJvrlNwDRGt68bTAqIf+s
        N+fsI3z0RwoJV
X-Received: by 2002:a1c:4b02:: with SMTP id y2mr4723155wma.115.1590595876812;
        Wed, 27 May 2020 09:11:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxL+M9svBpeGz1dmd2j1jjOm8lh//w8Ik9J0JQbYuBhPd7M71zBmJt18P2Dj2Pv/PipkmzSOQ==
X-Received: by 2002:a1c:4b02:: with SMTP id y2mr4723135wma.115.1590595876589;
        Wed, 27 May 2020 09:11:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id t185sm3187454wmt.28.2020.05.27.09.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:11:16 -0700 (PDT)
Subject: Re: [GIT PULL 0/3] KVM: s390: Cleanups for 5.8
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20200526093313.77976-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <42e54cbc-799a-9275-5084-04410b1eac33@redhat.com>
Date:   Wed, 27 May 2020 18:11:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526093313.77976-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/20 11:33, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.8-1

Pulled, thanks.

Paolo

