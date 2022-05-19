Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A985E52CAA9
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 06:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiESEFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 00:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiESEFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 00:05:09 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B9B9A98F
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:05:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s23so4514662iog.13
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PUGcGcgjY+PPbnlecm2Tn6LpDwtEL6DN9ddiFdVhU74=;
        b=T+YR2EVSbzWb5me6Hd1AfsMVOFmylR4frbRyEo2KCJuJHO3HHwmkWu02Z8Y1dTKbJ5
         JQX0nSnydKj5b7tTCwBk0w3NAUfW7sFgOszPoKlTYOxbiqeyvu2IjKWTKp0J1Gdl5ZTU
         oEK1ICmDSUohZMuz+rKpjG6gujbiho6bdPbV0TuMELvU9Gc/0w7QQ/OKkVn1K/vvEC8Z
         0s/TpQzcSS4g5+zlHMPLpGF27X6hD4zMMYdvXhd6GPhEd5CWArC6BK7YZhrTICtUR7I8
         LV/IdE/53VJTuMBNeJLe/2WtyZuvRcHTjJd9L8JDxhyut2o47xmvdsH53p5xrXbHhblt
         vCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PUGcGcgjY+PPbnlecm2Tn6LpDwtEL6DN9ddiFdVhU74=;
        b=QadQMH+xenILbg0DTm5Y7mS3JJao8dEPvLqAKiMf9A3S7kV+u53MrSHsr2RCHf4uT7
         rx/cBHrzFv+0bd2D2h0IFvD6NGKgJvJsVrgdMsMoFZ7RW/E4G1USH4a7zakiUanS9x3D
         /m4UazUGp3dSgvXnX06pUPvkQ/mI9Oq8RNyQwUHfDfwCcFAkmYlyT/KhfTpldy90kB7p
         cB2j5cgm3Irkt7qCyfYpgx70t8q9qsfO2NHtFmYtfxeHzgC0dXrUZKcI2s0H0qFRnSvZ
         z8Z+8dakRKUvusEO7y+t0RFFdvf6rMnjiJTsQb8bj0YK8cMc+hwXmeU9/QP4BIW2UB+g
         liig==
X-Gm-Message-State: AOAM530kNwcxKSZy+gHG+p+J7W6yk1HENKKnXNRFE2FYwaLOPcmski6i
        g1eEbYx5N4k1sFujhmYudyYGhQ==
X-Google-Smtp-Source: ABdhPJz0C2TDvwAse2KZ/T1HrIHSFXsQA+eJE1CxvgzyDE7OzlZrcIaSqLH+tGAQxWM1+N4uCAkomA==
X-Received: by 2002:a05:6638:4185:b0:32b:6a0d:90dc with SMTP id az5-20020a056638418500b0032b6a0d90dcmr1550180jab.193.1652933108425;
        Wed, 18 May 2022 21:05:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id x15-20020a6bfe0f000000b0065a6bef1568sm415715ioh.23.2022.05.18.21.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 21:05:07 -0700 (PDT)
Date:   Thu, 19 May 2022 04:05:04 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v3 04/13] KVM: selftests: aarch64: Export _virt_pg_map
 with a pt_memslot arg
Message-ID: <YoXB8FJT6Qwb/WFR@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-5-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 05:41:11PM -0700, Ricardo Koller wrote:
> Add an argument, pt_memslot, into _virt_pg_map in order to use a
> specific memslot for the page-table allocations performed when creating
> a new map. This will be used in a future commit to test having PTEs
> stored on memslots with different setups (e.g., hugetlb with a hole).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

I wonder if we should pay off the churn now to make _all_ arches have a
deeper call to map using memory from a particular memslot...

--
Thanks,
Oliver
