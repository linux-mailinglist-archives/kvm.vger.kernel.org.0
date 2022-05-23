Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A305531B74
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiEWTcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiEWTbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1FC99158B
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653333326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k/0kz+ejxdczhCliiE6lC8QVlLMBxfRksui59KA65qM=;
        b=dJ3d/4GgDguzJ4ExiVvqUixL9Neh/Fy2dFYComM/ZMEI9UXNqZ455sYNEam56KdEzBsTGP
        bkEQMJ/YrBc+GRjmMUPoFncLBo149+HoCIx39fPuiQY6aXmhq838SeXnflUZJEnhjgC2bB
        6tIrTgLIOnnrU9Mt3hT+cB3ZlwcbuBc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-d2-7KdFUMimpSNkN4RplEA-1; Mon, 23 May 2022 15:15:24 -0400
X-MC-Unique: d2-7KdFUMimpSNkN4RplEA-1
Received: by mail-ej1-f70.google.com with SMTP id n2-20020a170906724200b006fed87ccbb8so1594396ejk.7
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k/0kz+ejxdczhCliiE6lC8QVlLMBxfRksui59KA65qM=;
        b=SbrQSpHtBotoPkdxofzRhqmF/mtxXmZb2ftHPjAqjSOFq9INU9zbeXuHqVrvImOJd0
         wsroXz1VJdbNiu4t9Hf5zmC+hSWsPFptkbcftkwYjpd7P5GOZRMnQWRSKos27c1YPGIV
         pFYW5WRIUM7+uTI5SUilfkDAtdg+Mf+a0qQEpySMi8SqKkHLVZqUWcnkN1kTrGh+jp/w
         W05aQocjwejHxPjxJQm9GMQE+GNL5tLfostqm447gUt104gsDfbdHgx7Ap8q8rX8kfF8
         Qt2UPcbihBKdVy7mzrfwXyA3zPrf2K+fkX3jlxKIpUrtoTgqMwNy3yDDqfUrqLqsVu68
         Qorw==
X-Gm-Message-State: AOAM531rCi2ZlK9Xl8H4E23sZ0dsdqQ7zosk87nCiHYMrEYWUSwxDRlG
        D7MdoZToOHy0rGpLGKLvBXanFps7c0ljjFNn1lF7lMISKYYFeAws/B+F5JRh0j4uLGqQEbA7qf8
        lvvVBnzwVNdkL
X-Received: by 2002:a17:907:6d15:b0:6fd:d985:889b with SMTP id sa21-20020a1709076d1500b006fdd985889bmr21549075ejc.753.1653333323221;
        Mon, 23 May 2022 12:15:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgkCPhcAB33EYPZ90yGnEhKwoYAq64BHcNEOKNWqNDyz59/iBOtrFdjzxw5hQFuZHG1dBu+g==
X-Received: by 2002:a17:907:6d15:b0:6fd:d985:889b with SMTP id sa21-20020a1709076d1500b006fdd985889bmr21549058ejc.753.1653333323039;
        Mon, 23 May 2022 12:15:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c21-20020aa7c995000000b0042aaacd4edasm8624567edt.26.2022.05.23.12.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:15:22 -0700 (PDT)
Message-ID: <a1d7d9f9-bb9d-1b98-a073-85d835be0341@redhat.com>
Date:   Mon, 23 May 2022 21:15:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL 0/4] KVM: s390: Fix and feature for 5.19
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220523095625.13913-1-borntraeger@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220523095625.13913-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/22 11:56, Christian Borntraeger wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.19-1

Pulled, thanks.

Paolo

