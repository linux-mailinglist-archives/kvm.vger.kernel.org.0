Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA358DA99
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244538AbiHIO4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 10:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiHIO4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 10:56:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E38721583A
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 07:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660056994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGxrv7XQtNO3keosL308r0Cij251o3z/ur0FrqDoI+4=;
        b=hJulmw+ZFQ35YtNY1jZe22Y3cTIiWxOWBKJAoQ+zsD3BLQc7sd1O/IfqrdfxdJHnE1jyp0
        SIICFqrVan7hE4vj6n4im7jA8EmKEXRR27ZOSUZqNv5NQrq92uG71X3Fu8pFJ1Z+H53zA1
        RZgJj1BB2FkQOnVTgmNQUi69vG4jRJM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-64-1dJqAliANMmaJ9QkXTSonQ-1; Tue, 09 Aug 2022 10:56:33 -0400
X-MC-Unique: 1dJqAliANMmaJ9QkXTSonQ-1
Received: by mail-ed1-f69.google.com with SMTP id s21-20020a056402521500b00440e91f30easo2228722edd.7
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 07:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VGxrv7XQtNO3keosL308r0Cij251o3z/ur0FrqDoI+4=;
        b=Qyyn48INNHfEvvi2zWW8U01MkIq7abQfW6IGlMGymnFnQ3zGcSFAxI1hrzTtkYkTCJ
         xVOJYOgMsGTIiwihSt7tCxfdKbB1nWl3NW4alcmbzGSo1RS5he/4uBxd/AdXbKsJ+Bdv
         qSrIa7eMLYELwXRvWArLeLbBuaE3EFsINWoaAN1cxm10qNxHkNIqjcOY/LSSKZvEQcrd
         /eZ0xwcDbq/maV5rFgVsYZPSvzixWQTX9BriEFWKEHxAAaRvPywgBHIvU5t2GVycs/HU
         SvWeF1jQL9yBno/rDoSsBq6/pJZFmNO0aER/qBXjM7zUh0IlWQecy1GaDu0vaZRNbSG+
         zfUQ==
X-Gm-Message-State: ACgBeo25tWvGTMZiuigYSru+7SGv7dQ8HtzxYyQraoiofoVej9GoiGK/
        yEO9C0JDRnqj/puz6Rik3aexLeQsqfudTw6HTiQloHbDFZS7wso/beqMVuBFmz08UN/v/gXhn+i
        PpthvQdZxKBwQ
X-Received: by 2002:a17:906:9b92:b0:730:a237:40fe with SMTP id dd18-20020a1709069b9200b00730a23740femr17216955ejc.464.1660056990481;
        Tue, 09 Aug 2022 07:56:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5f1cNkl5dCUzgBPhLSk0CvUTcPt3OBTz40K/iS7nCpLQj1bk/lBBoLfz1heXvS9m2MUcTg6w==
X-Received: by 2002:a17:906:9b92:b0:730:a237:40fe with SMTP id dd18-20020a1709069b9200b00730a23740femr17216943ejc.464.1660056990257;
        Tue, 09 Aug 2022 07:56:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bd9-20020a056402206900b0043bbf79b3ebsm6156063edb.54.2022.08.09.07.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 07:56:29 -0700 (PDT)
Message-ID: <d3e719ea-af24-a06b-6ced-274e98504d89@redhat.com>
Date:   Tue, 9 Aug 2022 16:56:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 6/6] KVM: Hoist debugfs_dentry init to
 kvm_create_vm_debugfs() (again)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-7-oliver.upton@linux.dev>
 <Yu1pO/ovmMBktzpN@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yu1pO/ovmMBktzpN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/22 21:02, Sean Christopherson wrote:
> Heh, so this amusingly has my review, but I'd rather omit this patch and leave
> the initialization with the pile of other code that initializes fields for which
> zero-initialization is insufficient/incorrect.
> 
> Any objections to dropping this?

Yeah, I was going to say the same.  The points before and after this 
patch are far enough that I'm a bit more confident leaving it out.

Paolo

