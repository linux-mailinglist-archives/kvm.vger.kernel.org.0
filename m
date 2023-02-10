Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C493692257
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 16:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjBJPgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 10:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbjBJPgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 10:36:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15B4C148
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 07:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676043319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yD+2gE60M+uKlrJhZdt8CF0rRtAY0FIoY/ThDG+iZnc=;
        b=OPg+wSRGGBqatqS17f4Bh8r9TLmJAwDddg6k/t6IMMg+HKzSCF6jo43vqUsja7av9AgWYM
        XkHKc46QG3dl1tfqYruYiWz5n4aCakT5PeYPQT5+3o1vZrj1f7UGHSEuNtvcop/08rEPMn
        6F90PXatTnuc7giLtJ2HhouagCDKCM8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-A78AAalSMGiI61LPQ_uTJg-1; Fri, 10 Feb 2023 10:35:14 -0500
X-MC-Unique: A78AAalSMGiI61LPQ_uTJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 395FB811E6E;
        Fri, 10 Feb 2023 15:35:14 +0000 (UTC)
Received: from localhost (unknown [10.39.193.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E83261415113;
        Fri, 10 Feb 2023 15:35:13 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v5 3/3] qtests/arm: add some mte tests
In-Reply-To: <a7904d6e-c8e5-055b-34f7-8ea2956ec65f@redhat.com>
Organization: Red Hat GmbH
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-4-cohuck@redhat.com>
 <a7904d6e-c8e5-055b-34f7-8ea2956ec65f@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 10 Feb 2023 16:35:12 +0100
Message-ID: <87h6vt8rf3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06 2023, Eric Auger <eauger@redhat.com> wrote:

> Hi,
>
> On 2/3/23 14:44, Cornelia Huck wrote:
>> Acked-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
> Still as you need to respin I think adding a short commit msg wouldn't
> hurt ;-) Add new cpu MTE feature tests with TCG+virt tag memory and
> TCG-no tag memory (default) attempting to set cpu mte option on/off. No
> real test for KVM because ../..

Ok, I'll add some lines :)

>> ---
>>  tests/qtest/arm-cpu-features.c | 75 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 75 insertions(+)

(...)

>> +static void mte_tests_default(QTestState *qts, const char *cpu_type)
>> +{
>> +    assert_has_feature(qts, cpu_type, "mte");
>> +
>> +    /*
>> +     * Without tag memory, mte will be off under tcg.
>> +     * Explicitly enabling it yields an error.
>> +     */
>> +    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }"=
);
>> +    assert_error(qts, cpu_type, "mte=3Don requires tag memory",
>> +                 "{ 'mte': 'on' }");
> Sorry in v4 I reported I preferred the pauth msg, clarifying now:
>
>     assert_error(qts, cpu_type, "cannot enable pauth-impdef without pauth=
",
>                  "{ 'pauth': false, 'pauth-impdef': true }");
>
> Here would translate into cannot enable mte without tag memory.

Oh, so you mean that I should adapt the message generated by the code?

[did not get around to the rest of it this week, will try again next
week]

