Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED86867C94A
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 11:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbjAZK7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 05:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237057AbjAZK7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 05:59:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235D1BB8D
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 02:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674730682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pUtnlRWuSV9rzF4bHOmBDZppyOE20q92Y5J7hglnV3g=;
        b=fUkqcNc8DWHHRGBY+MFFYlZkB4y3UW6vrImUJp48mre5Mn3NARr9qoYGe0BJAtL6+/LfTr
        x/FyeMbxyRztPCOFIURt8eYU8ZCfOoi3JCViHnLsI+vH/4drkwi9uo6SeDMXUgw0tqajBM
        DGlCjN4PRKqykD1Yx8Xgt6EmikjwJHU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-0Lo4XJvHPPuiSLgXNcAMGQ-1; Thu, 26 Jan 2023 05:57:56 -0500
X-MC-Unique: 0Lo4XJvHPPuiSLgXNcAMGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5603F3C025C6;
        Thu, 26 Jan 2023 10:57:56 +0000 (UTC)
Received: from localhost (unknown [10.39.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3DC4C15BAD;
        Thu, 26 Jan 2023 10:57:53 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 2/2] qtests/arm: add some mte tests
In-Reply-To: <be81e9e3-1669-4627-562e-30ab0a98c8fc@redhat.com>
Organization: Red Hat GmbH
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-3-cohuck@redhat.com>
 <be81e9e3-1669-4627-562e-30ab0a98c8fc@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 26 Jan 2023 11:57:50 +0100
Message-ID: <87a625y34h.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23 2023, Eric Auger <eauger@redhat.com> wrote:

> Hi Connie,
> On 1/11/23 17:13, Cornelia Huck wrote:
>> Acked-by: Thomas Huth <thuth@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> Maybe add some extra information about what tests are run. Also you
> could add an example of test invocation so that any people interested in
> can easily run those new tests?

Hm, it's just a part of the normal, standard qtests -- not sure what I
should add there?

>
>> ---
>>  tests/qtest/arm-cpu-features.c | 76 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 76 insertions(+)

(...)

>> +static void mte_tests_default(QTestState *qts, const char *cpu_type)
>> +{
>> +    assert_has_feature(qts, cpu_type, "mte");
>> +
>> +    /*
>> +     * Without tag memory, mte will be off under tcg.
>> +     * Explicitly enabling it yields an error.
>> +     */
>> +    assert_has_feature(qts, cpu_type, "mte");
> called twice

Ok, that's probably some kind of rebase artifact.

>> +
>> +    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
>> +    assert_error(qts, cpu_type, "mte=on requires tag memory",
>> +                 "{ 'mte': 'on' }");
> nit. with pauth_tests_default form: cannot enable mte without tag memory

Not sure what you mean here?

>> +}
>> +
>>  static void test_query_cpu_model_expansion(const void *data)
>>  {
>>      QTestState *qts;
>> @@ -473,6 +539,7 @@ static void test_query_cpu_model_expansion(const void *data)
>>  
>>          sve_tests_default(qts, "max");
>>          pauth_tests_default(qts, "max");
>> +        mte_tests_default(qts, "max");
>>  
>>          /* Test that features that depend on KVM generate errors without. */
>>          assert_error(qts, "max",
>> @@ -516,6 +583,13 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>>          assert_set_feature(qts, "host", "pmu", false);
>>          assert_set_feature(qts, "host", "pmu", true);
>>  
>> +        /*
>> +         * Unfortunately, there's no easy way to test whether this instance
>> +         * of KVM supports MTE. So we can only assert that the feature
>> +         * is present, but not whether it can be toggled.
>> +         */
>> +        assert_has_feature(qts, "host", "mte");
> why isn't it possible to implement something like
>         kvm_supports_steal_time = resp_get_feature(resp, "kvm-steal-time");
> Could you elaborate?

I really should have written that down in detail, but I _think_ that's
because of OnOffAuto... if the prop is not set explicitly, we don't know
what is supported. Unless someone has an idea how to work around that?

