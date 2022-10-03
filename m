Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6D5F2904
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 09:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJCHMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 03:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJCHMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 03:12:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBF810573
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 00:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664781126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=154RHrFZO+WLhc4AZtKILRBnzyj1+ANVpkTzON8SMRE=;
        b=Im2cAXmn0zHz9zmr67p3XrgB1+fqCKkkmA1Vd5KYUQlIJmfx9FIVmsZdnJSWV+5doYSEJk
        gFa/e96QOokLOKP/mxRvOHnixNdNLJPzQHFXmzTJJLG07Fq+G3yulHg2tlt9tMLD0Y8VA6
        nYdOmYMGKpdTl+3AqM/iA/ipomVnrqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-DNNXoNyEORuyL37LdV98XA-1; Mon, 03 Oct 2022 03:12:03 -0400
X-MC-Unique: DNNXoNyEORuyL37LdV98XA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F24CD85A5B6;
        Mon,  3 Oct 2022 07:12:02 +0000 (UTC)
Received: from starship (unknown [10.40.193.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E21D40C206B;
        Mon,  3 Oct 2022 07:12:01 +0000 (UTC)
Message-ID: <271109e5a0929a2d36943ec82d459e4bb3d69f0d.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] x86: nSVM: Add testing for
 routing L2 exceptions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
In-Reply-To: <23878d4c-52ec-9a07-1189-7a547ec9c9d0@amd.com>
References: <20220810050738.7442-1-manali.shukla@amd.com>
         <d62703a8-7c8b-eab4-cf35-bb520312d0d9@amd.com>
         <1b17bc6f-c7c6-2d3a-476c-7cf0ea24f4cc@amd.com>
         <bae31123-27ae-5996-affb-93a7199a66f1@amd.com>
         <23878d4c-52ec-9a07-1189-7a547ec9c9d0@amd.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Mon, 03 Oct 2022 10:07:36 +0300
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-10-03 at 09:45 +0530, Manali Shukla wrote:
> On 9/26/2022 10:04 AM, Manali Shukla wrote:
> > On 9/19/2022 10:11 AM, Manali Shukla wrote:
> > > On 8/29/2022 9:41 AM, Manali Shukla wrote:
> > > > On 8/10/2022 10:37 AM, Manali Shukla wrote:
> > > > > Series is inspired by vmx exception test framework series[1].
> > > > > 
> > > > > Set up a test framework that verifies an exception occurring in L2 is
> > > > > forwarded to the right place (L1 or L2).
> > > > > 
> > > > > Tests two conditions for each exception.
> > > > > 1) Exception generated in L2, is handled by L2 when L2 exception handler
> > > > >    is registered.
> > > > > 2) Exception generated in L2, is handled by L1 when intercept exception
> > > > >    bit map is set in L1.
> > > > > 
> > > > > Above tests were added to verify 8 different exceptions.
> > > > > #GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.
> > > > > 
> > > > > There are 4 patches in this series
> > > > > 1) Added test infrastructure and exception tests.
> > > > > 2) Move #BP test to exception test framework.
> > > > > 3) Move #OF test to exception test framework.
> > > > > 4) Move part of #NM test to exception test framework because
> > > > >    #NM has a test case which checks the condition for which #NM should not
> > > > >    be generated, all the test cases under #NM test except this test case have been
> > > > >    moved to exception test framework because of the exception test framework
> > > > >    design.
> > > > > 
> > > > > v1->v2
> > > > > 1) Rebased to latest kvm-unit-tests. 
> > > > > 2) Move 3 different exception test cases #BP, #OF and #NM exception to
> > > > >    exception test framework.
> > > > > 
> > > > > [1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
> > > > > [2] https://lore.kernel.org/kvm/a090c16f-c307-9548-9739-ceb71687514f@amd.com/
> > > > > 
> > > > > Manali Shukla (4):
> > > > >   x86: nSVM: Add an exception test framework and tests
> > > > >   x86: nSVM: Move #BP test to exception test framework
> > > > >   x86: nSVM: Move #OF test to exception test framework
> > > > >   x86: nSVM: Move part of #NM test to exception test framework
> > > > > 
> > > > >  x86/svm_tests.c | 197 ++++++++++++++++++++++++++++++++++--------------
> > > > >  1 file changed, 142 insertions(+), 55 deletions(-)
> > > > > 
> > > > 
> > > > A gentle reminder for the review
> > > > 
> > > > -Manali
> > > 
> > > A gentle reminder for the review
> > > 
> > > -Manali
> > 
> > A gentle reminder for the review
> > 
> > -Manali
> 
> A gentle remider for the review
> 
> -Manali
> 
I will review this very soon. Sorry for not getting to it earlier.

Best regards,
	Maxim Levitsky

