Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D814206E5
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 09:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhJDIAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:00:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhJDIAv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633334342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JWKzHhBNVWSFAM9ozeumGeLFGzAACD+GMCb+b6UXpM0=;
        b=du2hzf5aH6GeyBA180sTXgdTHczUj/Yu5uQLkY7+rFadm5gRbThjO4sVmqGSFSoCEOlZKN
        /np7o6BJ3YDCR9EA1HkXn99M4jgQ5okiOxUcIPh3rKwAsDeN9XwsSPznhGJAFnMIW5jeH2
        69/ByBKORMPx3U/foTVS5WEUZgwqaDo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-rv94yKIBMyqYjfb46cnfXQ-1; Mon, 04 Oct 2021 03:59:01 -0400
X-MC-Unique: rv94yKIBMyqYjfb46cnfXQ-1
Received: by mail-ed1-f70.google.com with SMTP id y15-20020a50ce0f000000b003dab997cf7dso12813613edi.9
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 00:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JWKzHhBNVWSFAM9ozeumGeLFGzAACD+GMCb+b6UXpM0=;
        b=LDHrOPe0771GGytNJNSctr1Tp7kXkfoa88K5hnPuMkw8sqMnP4hHAiSanPp/+i1Z+v
         j02NBHCdJ6hZfpahJfOazEvzfXEr/2Y3O/DFDfRaBhAqr2EeGFtOwd6hdXMDO+Y6TlE6
         zDQMEQeiNfc+JiSOPDpUZONCPsz5vePvn643dkIQoUrxWeA79ZE8D0V1kATlM46EMwf8
         F5xA5snXHdvrnLDLsDVCAZxzof0U9m4pwNlMmuX1mmWuOUd4XYGo7Sa+nHEIIm0B0Z2t
         f6sN/DibNGNMF+glFkfuUr4xF4Mz0utBVkgZcAIptXAV42IAMffKAP+L8hzZNsWWW6a/
         HjPQ==
X-Gm-Message-State: AOAM533+wI1kimC77KWt2m/wLABR7yRAdoT1quwxpJHbhviQog4XNXd6
        oQiQppJdCUrLlFbdOIXeK8Mn8SMUX2tsjxMrH2eMNcYfV2sAsjV5DVVIrhfhLhXj577/gokWYmD
        ABYKa/wQIUQle
X-Received: by 2002:aa7:c911:: with SMTP id b17mr7041841edt.5.1633334340161;
        Mon, 04 Oct 2021 00:59:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz4OR73zDiy9DChgDRER5fiNhRZ8aL0vtSC9rUlUA4MiSMjlQA7FTEerKyTi4bzfUJP4G0Lw==
X-Received: by 2002:aa7:c911:: with SMTP id b17mr7041828edt.5.1633334340004;
        Mon, 04 Oct 2021 00:59:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g9sm6224244ejo.60.2021.10.04.00.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 00:58:59 -0700 (PDT)
Message-ID: <4e940025-bca2-c694-ff36-e3d0fe0dd304@redhat.com>
Date:   Mon, 4 Oct 2021 09:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL 0/1] KVM: s390: allow to compile without warning with
 W=1
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20210930125440.22777-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210930125440.22777-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/21 14:54, Christian Borntraeger wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.15-1

Pulled, thanks!

Paolo

