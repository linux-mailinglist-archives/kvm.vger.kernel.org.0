Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFA44D1BCF
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbiCHPgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347837AbiCHPgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C21DD4E3B8
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646753754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o2ZKLGm45POEAHtlCDYfMRey2ErkAYLs4N1sMrLzfvY=;
        b=R+kDkEV0J3cHvRNSNopuSC2zz2jMHAXXuZiER40WWqsSSOwZ2rQjawlHjaksVmnBZ6VpZj
        kXB+fHPdlqPbSjv9ldOYKmwz0yQLqKHEWJY+yphbkQY62tNwCbtzgTlYhixK5r3W3UWm4k
        K33JO3KLPx824yUeyekyBphFOKuTcXM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-5_DMp1NyMhuVIc99mazwMw-1; Tue, 08 Mar 2022 10:35:53 -0500
X-MC-Unique: 5_DMp1NyMhuVIc99mazwMw-1
Received: by mail-ej1-f70.google.com with SMTP id l24-20020a170906a41800b006da873d66b6so7582360ejz.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:35:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o2ZKLGm45POEAHtlCDYfMRey2ErkAYLs4N1sMrLzfvY=;
        b=dJ5509nnniGSgaaCsB8gsSwi8Ovkkp9/CYLMwvtW8vh5hGRaDa/WmFZXTR4IEHMzcP
         7zfW2xKAKZhoH2igT9mzB2AeJo87gF7UhrNMmZSFnodVpHUEJma89NHM/Ezm8N/Dx25+
         2egS6WuMyzOlnJBoeXyYxuQ9yv0h1eWQHrROn24SgjJr4q77sn0mc4ion2FKGXPGfAji
         biPyIV+6sYEjKZFH0Rw3SaVcRSUj6o2KEO8wquilWHOr/l1ObbXItaQuZK4WpzZLUb7O
         oGdhG5voQgc0S9oA2v2VyTO5GXpYgjT4NXZ3Fehvuqd4tcPNK0683snVrvsRhh+RGwSQ
         dmfQ==
X-Gm-Message-State: AOAM533lTUzcFSN73B6UPVSZ0QPKdVJJr4+N4wgyBFW99SKe8IRqJnnv
        yEQFoHG1lHtMHQJ1ESfEEMP19bLPm84vWW/e9EHlDCVUD1fW1DgLFJuxmPscqCCRvip7UDD7L3l
        A8cbnlM9q/ahd
X-Received: by 2002:a17:907:94c1:b0:6db:67:7214 with SMTP id dn1-20020a17090794c100b006db00677214mr13124104ejc.180.1646753752236;
        Tue, 08 Mar 2022 07:35:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7g8KfoOxuITvnPmr3CL8+6ovIAFSA8lEJmlV9LVIa7qM0pDzO/0hCD9zBBmhdkvxKne/r0w==
X-Received: by 2002:a17:907:94c1:b0:6db:67:7214 with SMTP id dn1-20020a17090794c100b006db00677214mr13124081ejc.180.1646753751918;
        Tue, 08 Mar 2022 07:35:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id hg11-20020a1709072ccb00b006cee4fb36c7sm6097747ejc.64.2022.03.08.07.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 07:35:51 -0800 (PST)
Message-ID: <cc543e9d-6891-b53d-b34c-7cd7406e5dc7@redhat.com>
Date:   Tue, 8 Mar 2022 16:35:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH 0/3] Move nNPT test cases to a seperate
 file
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
References: <20220228061737.22233-1-manali.shukla@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220228061737.22233-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/22 07:17, Manali Shukla wrote:
> Commit 916635a813e975600335c6c47250881b7a328971
> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
> clears PT_USER_MASK for all svm testcases. Any tests that requires
> usermode access will fail after this commit.
> 
> If __setup_vm() is changed to setup_vm(), KUT will build tests with
> PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests
> to  their own file so that tests don't need to fiddle with page tables
> midway.
> 
> The quick approach to do this would be to turn the current main into a small
> helper, without calling __setup_vm() from helper.
> 
> There are three patches in this patch series
> 1) Turned current main into helper function minus setup_vm()
> 2) Moved all nNPT test cases from svm_tests.c to svm_npt.c
> 3) Change __setup_vm to setup_vm() on svm_tests.c

What ideas do you have for SVM tests that require usermode access in the 
test (not in the guest)?

Paolo

