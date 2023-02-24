Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11166A169E
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 07:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBXG3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 01:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBXG3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 01:29:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630D13773C
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 22:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677220126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7pl2BtrC5PUOzOs2PHa1qtj9M7IuWelH2zXaYyObUOI=;
        b=f5McJGU2f/wVuP12/eaoOGzf9vBoY+Jbb0YDDJrzZsUbMRj4IbWWrQpmPHaQ7KLNjEjto/
        QuJtFyLzGNrXIOePZze5OqJ6l4RmD/RemFd0PKF6eMU8uQLUHBoRsqtnJn0LnrST7Pj5nr
        Y/cbspqUEIqpY29APKDtb+NuKRTsPaU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-k6Vc5K7tMYyovIf0AqUU7w-1; Fri, 24 Feb 2023 01:28:42 -0500
X-MC-Unique: k6Vc5K7tMYyovIf0AqUU7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64D2C1C04B7B;
        Fri, 24 Feb 2023 06:28:42 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44C7A1121314;
        Fri, 24 Feb 2023 06:28:42 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 2393E21E6A1F; Fri, 24 Feb 2023 07:28:41 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Juan Quintela <quintela@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paul Moore <pmoore@redhat.com>, peter.maydell@linaro.org
Subject: Re: Fortnightly KVM call for 2023-02-07
References: <87o7qof00m.fsf@secure.mitica> <Y/fi95ksLZSVc9/T@google.com>
Date:   Fri, 24 Feb 2023 07:28:41 +0100
In-Reply-To: <Y/fi95ksLZSVc9/T@google.com> (Sean Christopherson's message of
        "Thu, 23 Feb 2023 14:04:39 -0800")
Message-ID: <87356v4lwm.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jan 24, 2023, Juan Quintela wrote:
>> Please, send any topic that you are interested in covering in the next
>> call in 2 weeks.
>> 
>> We have already topics:
>> - single qemu binary
>>   People on previous call (today) asked if Markus, Paolo and Peter could
>>   be there on next one to further discuss the topic.
>> 
>> - Huge Memory guests
>> 
>>   Will send a separate email with the questions that we want to discuss
>>   later during the week.
>> 
>> After discussions on the QEMU Summit, we are going to have always open a
>> KVM call where you can add topics.
>
> Hi Juan!
>
> I have a somewhat odd request: can I convince you to rename "KVM call" to something
> like "QEMU+KVM call"?
>
> I would like to kickstart a recurring public meeting/forum that (almost) exclusively
> targets internal KVM development, but I don't to cause confusion and definitely don't
> want to usurp your meeting.  The goal/purpose of the KVM-specific meeting would be to
> do design reviews, syncs, etc. on KVM internals and things like KVM selftests, while,
> IIUC, the current "KVM call" is aimed at at the entire KVM+QEMU+VFIO ecosystem.
>
> Thanks!

Sounds fair to me.

