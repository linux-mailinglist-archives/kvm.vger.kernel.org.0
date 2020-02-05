Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304641533BD
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgBEPV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:21:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47327 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgBEPV3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 10:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbAqmvDp8yZagHd04oR8JJifOFLKAv/diEDneSy9GDE=;
        b=G/MrFBC1kkk0BvzIC4hjsEgkEQZdtmcb4UkZPmtexL7n4NaW6zv0S5BiaBPO2k613ukh7P
        oPv3yvrA4wz+bc92K/S1YnMqsH48Uo3PgUWJeApA9uZBXX2dzWuByi/VBZpFoADtVHcXv8
        LSEgIriHloDIcuPcxwcEwjfIkLo8KlA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-PNEmAhXROk-1L1ZZvSTxHA-1; Wed, 05 Feb 2020 10:15:20 -0500
X-MC-Unique: PNEmAhXROk-1L1ZZvSTxHA-1
Received: by mail-wm1-f70.google.com with SMTP id d4so954655wmd.7
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:15:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jbAqmvDp8yZagHd04oR8JJifOFLKAv/diEDneSy9GDE=;
        b=ipw6xsZ0QIQiA+0WhWYsM4Y4LyDQXKJOYvtrjulwBZwv0tudnvvscyu0nfPYO1C8RT
         WSscu7MujHOjt8MWcLZAa3onepEuiJsqaNuFpnd6Zigot+wfkODS3G0wQw9E0NNarKwZ
         HHCVa8sAborQJ3LqcWle4ut1ALrVRM3kvVOblTbiwAZy0do/Y4d6m+DzraVt/Lw5YtS9
         YMWUc8+aytLGJzYt7FkZx3SH1YQ/fc5m7W/clcq8j7oI5bWvuW6El7pya5hIBSdMyJea
         SSe+tvpOmFFGDumu7gIkLlR2NKHFHtSoNqyJvWcGlGVyWYgXM2BwGRvCK2eEsMhJlwTW
         nn7Q==
X-Gm-Message-State: APjAAAVZ601wG/0P7YYKgG0Q6V8RcZHaBc4aHtpQ8gDJ5gvlTqMG/MzK
        1AIJQJQzX3gN0iAZUT888fIXuWRDGx5KQ4+dfTWfAfKA3rnhk8OJ0InX2X9GtwAuJ2N4aRu4lqo
        a1/z52kbbNmU6
X-Received: by 2002:adf:cd03:: with SMTP id w3mr30032416wrm.191.1580915718014;
        Wed, 05 Feb 2020 07:15:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvLhdRSWgM2maQ+SNfiAl7MjWC1I05ytVdRYhXthbKcs88COY/fnHNUifaodKxjXoLAz44eQ==
X-Received: by 2002:adf:cd03:: with SMTP id w3mr30032401wrm.191.1580915717856;
        Wed, 05 Feb 2020 07:15:17 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x14sm8059396wmj.42.2020.02.05.07.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:15:17 -0800 (PST)
Subject: Re: [GIT PULL 0/7] KVM: s390: Fixes and cleanups for 5.6
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20200131150348.73360-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cea0211f-5c7c-3838-d682-955e0505c8a4@redhat.com>
Date:   Wed, 5 Feb 2020 16:15:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200131150348.73360-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/20 16:03, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.6-1

Pulled, thanks.

Paolo

