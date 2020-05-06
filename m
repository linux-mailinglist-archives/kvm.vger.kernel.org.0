Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B0F1C7682
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgEFQci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:32:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729414AbgEFQch (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:32:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588782756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eto8D2lggcYgztZWQWQcJNTVs0npVvmn/qS+mjsJ8Oc=;
        b=XrPNyImu6+bJubB8zKSmp/qYKuD0SIfwq+/TMmte+Xqv5LSJuT8N81650R5rjkSip0CuD9
        x1CR7kochL1jsg1nUq18uTOe+mVgoqnGpZqM1TKI07dEcwZ0frVhNDUGnEOztTp+tUmzS3
        LeFO/K9Xh9vL/i5jz39jSY3eqPt1LkA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-6h32-QXKMymEPoE7Hwkg0A-1; Wed, 06 May 2020 12:32:35 -0400
X-MC-Unique: 6h32-QXKMymEPoE7Hwkg0A-1
Received: by mail-wr1-f69.google.com with SMTP id f15so1613936wrj.2
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eto8D2lggcYgztZWQWQcJNTVs0npVvmn/qS+mjsJ8Oc=;
        b=MjcZZBUjhUyJO/ZYMzqgJKIvoGL6H/0hY3PCjY7yGc0RvdAzdih0/qntcq3nmsYrQX
         bA4j9H+i2YFjVDOO2QcJAFvKzkYKiDssXEeHAB5xFnrUw+FzG1fJQazGSyzFFK3dUCdD
         gfO/c3Gwdq9a+d5DZOF9YU3K0lreYm8DbtPVWXf6QTQj7B4rM3w2AUpRcFZZFbplLx20
         +MfM9YxICE+03Afoe17cbytfL6gHX7sYj8SMdgC+J4nAlKITGCcGDikOzbATYpwWOGPi
         kDdZDL3lqlinvuUqO+I6CRgjWilXWfIfG27YJOmlCWUVLKDqRp7vMiZIE+RgZwnsH0TD
         pdNg==
X-Gm-Message-State: AGi0PuZcJ8UdwC2h0s6Bq7RTzpF9OXL3L4oBjmagIrVEIQJ8O4holCYF
        QIHEEZaEoG8UCW2s+/GbwKb5z0RVupmkRCfqes2dAj139JgJNP16ZVqKqvzlcB88NWfWrHTe1pz
        UtRmKX+TWiM3e
X-Received: by 2002:a1c:7905:: with SMTP id l5mr5808912wme.5.1588782753813;
        Wed, 06 May 2020 09:32:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypIJSexrvgOJNLVQa/etXRciWaQ/D774pIxh3E6Vt7DGP7fIhMjBImMDvouP3JiXnqRE9kjItg==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr5808887wme.5.1588782753631;
        Wed, 06 May 2020 09:32:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id y3sm3407680wrt.87.2020.05.06.09.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 09:32:32 -0700 (PDT)
Subject: Re: [GIT PULL 1/1] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Qian Cai <cailca@icloud.com>
References: <20200506115945.13132-1-borntraeger@de.ibm.com>
 <20200506115945.13132-2-borntraeger@de.ibm.com>
 <bcd98cbd-1e28-47a2-6cbd-668da4ddb9f5@redhat.com>
 <fe991071-25d0-3842-73cc-23cb365850f3@de.ibm.com>
 <a8688ff1-edc6-fdd8-9575-adbf726f9f06@redhat.com>
 <328f4d06-5c1e-5255-cb4f-e8534f2171bf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e955f2f0-904b-394e-fa19-e3a461ecc92f@redhat.com>
Date:   Wed, 6 May 2020 18:32:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <328f4d06-5c1e-5255-cb4f-e8534f2171bf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 15:09, David Hildenbrand wrote:
> IIRC, it's perfectly valid - according to the documentation - to ignore
> ECA_APIE. That's the weird thing about effective controls. You don't
> really know what you get in the end.

Ah okay, then yeah it could be considered a quality of implementation
issue but not a bug.  Thanks for the lecture! :)

Paolo

