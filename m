Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA4523180
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfETKkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:40:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40072 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfETKkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:40:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so14011627wre.7
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Npi8Ht/enySYexRXn6PiDHIk8ELqfdJW0KR70Q1Ujmo=;
        b=j4iNXwe+VOHQIwWUO4yqo7Rd798DaJa9Z8CbHnLiQxNouBrrYv/poVBkmnGQVdQvzi
         JQkRYJv3xuGbtgPyzLTaQ8kQyZeMsX4ZTlxWvbIiZc93ZbZAJDrGVvT1RdjczTnlV14q
         331MWTaImCPbaOISPS5mh+Zqqgl1pkCvbTGYDFEKCb4aoMGSwuKKHAmWjCKvMFQwhVGu
         GVIu8Urpp3ph0ZrnO3MHIYACvKeRRcAz6QOxpZynqlTw6JqC5XZw7BU4e+TNdaOthV1q
         tmpYA1Wu07PILLyAj+OS/sSTpLtVfFXsavjJxmo30f5AaCWC+4ifT/LcsSvZQT5b33v6
         pn4g==
X-Gm-Message-State: APjAAAVwTO9kx08VD7LrhG17wqcEFYu/HnBiJyYwrj/ew57UzAxgJgZM
        NIyTdiGvv6tOjnpSJHRizemWbw==
X-Google-Smtp-Source: APXvYqytptBgJ8n/W1J3wxlBrGAipoGMB+/e14oasouVR8LMFTtdelW2vg3Uok5icD+/rOXy6iqABw==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr8989845wrj.272.1558348843578;
        Mon, 20 May 2019 03:40:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id s10sm14464267wrt.66.2019.05.20.03.40.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:40:43 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: s390: Fixes for 5.2-rc2
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
References: <20190520103055.246818-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b6f4acd8-df71-78f5-bb1a-bbc2dc1f4a5e@redhat.com>
Date:   Mon, 20 May 2019 12:40:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520103055.246818-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 12:30, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.2-1

Pulled, thanks.

Paolo
