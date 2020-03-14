Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D452185988
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgCODCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:02:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726610AbgCODCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584241336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hbJyE5xwqVIitBkS3hnaFSQEPHc+aUC/LLikTGDcmKs=;
        b=S94BnV/UIoxjzKinNnEqRI5+MC3WJat3/lUHUPcg9hznd/nnyOESAfLhtIka5rIi/FvDLw
        ID/cOMA6iVDgD9iE9vB9mfvmTvM6t75CkpknPcqRPUHudPLaSXqGUTFznzWhXcTGOM9M0v
        wyXPJkiiPn75B4KU51sIB5yz9M7koUo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-4Bpk7a-PNha4FeB_523zcQ-1; Sat, 14 Mar 2020 06:59:36 -0400
X-MC-Unique: 4Bpk7a-PNha4FeB_523zcQ-1
Received: by mail-wr1-f70.google.com with SMTP id q18so5772310wrw.5
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 03:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hbJyE5xwqVIitBkS3hnaFSQEPHc+aUC/LLikTGDcmKs=;
        b=jTHzemaEiYo+oz+t6Px+7UnHTuZJ9dfVbVmc9WlBgMIemWzplF57aSMznINlaqseIQ
         EANr+78kpFQ23FgZHxdAkzb7hzVVMdyT3uDZRlaXi2liawmWQ4L1KMNfp25M5u7YWzLf
         9+jLFGete0oj0YhRu1exij6KXOviR6EhSzCtxNt5J20yoHgwQUigntMEQETAoK5ColIh
         MAPdqX834XBm++LvxKSxdpr38/8TmVtpe90bgS7HCH8ygjiHBjLO2l7yqeXelUGoa+Ru
         FRjArtsJFFx5/7n52Fb2v2YK1b9ITBbgM9AiTAJuA2yIChlqlzWK1WoSxIY/3lcWKXTR
         Nldg==
X-Gm-Message-State: ANhLgQ0mUOAffFIJYhsNwkEptKcnNi+tiJ/f53q8Nr3rtF2LLX81oBga
        YUfg2LHvgkydeIvzTQBqp7DLJZHG580V6CLfQIJa1axbRhTLSd9ilc1ZQGP/Nqj90alI4bOPlE9
        pPZq1rGxfZ9nS
X-Received: by 2002:adf:e906:: with SMTP id f6mr23599857wrm.108.1584183575490;
        Sat, 14 Mar 2020 03:59:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsxB384LhhFaGJTP6mS6+dEUF5GBh32yBpthvK6EtaJT62jRn7oFwehdv3+6f/b7HUvw33Tig==
X-Received: by 2002:adf:e906:: with SMTP id f6mr23599849wrm.108.1584183575311;
        Sat, 14 Mar 2020 03:59:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id y200sm18937265wmc.20.2020.03.14.03.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 03:59:34 -0700 (PDT)
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix for 5.6
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20200312142750.3603-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b0298c5-c040-e5b6-aea5-4170f3152ef7@redhat.com>
Date:   Sat, 14 Mar 2020 11:59:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312142750.3603-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/20 15:27, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.6-1

Pulled, thanks.

Paolo

