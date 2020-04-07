Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3E1A0DA8
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgDGMbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 08:31:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728555AbgDGMbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 08:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586262704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cf6HeBCxjUruxoGI91yxHPOxsiwFayWbRoQQU5L19fY=;
        b=LXwB5128GEPprczYIxT41NyNiS/zKkpwNmOVQTRAORb+10/3h/q1oCzZTWuDr42qx5xA9x
        EyLzN5agVH94LOnfYEVls8r3mKfOxBd4N+Q1JyEb+Uq1/J77oUnx0T0k/cHAHhvbNmKX38
        j626c5BgQilAWbIH7FROKsiAAGeVB1A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-Jqc42m-HOkeUEYZNZ916Ow-1; Tue, 07 Apr 2020 08:31:42 -0400
X-MC-Unique: Jqc42m-HOkeUEYZNZ916Ow-1
Received: by mail-wm1-f72.google.com with SMTP id u6so661544wmm.6
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 05:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cf6HeBCxjUruxoGI91yxHPOxsiwFayWbRoQQU5L19fY=;
        b=qb6VVWmT+alA2S4e76kpA9BggCuBmmn+Z4/gUma4ml0tErC/XerVjgqJ+AVK+YmUIR
         P0k9DWo066lZT4kU4vVbNLDgSPTgf6dkBahNliz7CQe3EpGXtsEV9TxAHxu7t4IxeO6P
         uqXPEu//OOvu4VRO7mH63AS658skX/oE4UHfOOXUSz1ACde4xt4IDIPk7lyRqx9xzvgx
         uEtvZ11kHqO1+Lt7ECFnyrtNbcSJ8OpR1mKKF4s7mVqNMQ4wxVvilZiwhugL6JSCVjik
         Lp9NkstX7KWPC/zYSzanY1O/VUSCbXcdIs4sP7uwfzFj7sZooCXMmXB9817PQrKGNFza
         /RrA==
X-Gm-Message-State: AGi0PuZ36cROwEuuM4QWHzIQ2MmXi+QJkKNkW5rxBE8VVmObJ/EDt1Ar
        MVlsg8RejSxqWkzeHZ5Ywy8HGTqsAJjCbmLovNWLbgS89gHyQtEsqenwlksXhUzK/3NQMPG6rg/
        Q6qozwXnlgxJw
X-Received: by 2002:adf:f4cc:: with SMTP id h12mr2501445wrp.171.1586262700997;
        Tue, 07 Apr 2020 05:31:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypLANV6ylf8gqaJS0lQU1t8GvWYfkTU8ZNu5aQ3z7vaNssQcTd5L1/eQrY2HblkUGGXPtLF3yQ==
X-Received: by 2002:adf:f4cc:: with SMTP id h12mr2501423wrp.171.1586262700731;
        Tue, 07 Apr 2020 05:31:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id t11sm30316985wru.69.2020.04.07.05.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 05:31:40 -0700 (PDT)
Subject: Re: [GIT PULL 0/3] KVM: s390: Fixes for vsie (nested hypervisors)
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20200407114240.156419-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b9689a91-9df1-9e37-03b7-156691f1ccd4@redhat.com>
Date:   Tue, 7 Apr 2020 14:31:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200407114240.156419-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/20 13:42, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.7-1

Pulled, thanks!

Paolo

