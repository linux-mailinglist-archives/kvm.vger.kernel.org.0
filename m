Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BDC5A6CB0
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiH3TCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiH3TCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:02:13 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463115F22A
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:02:12 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id i13-20020a056e02152d00b002e97839ff00so8944853ilu.15
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc;
        bh=PfjwHn1bJsvfyD146B3GFr85bVvbp9LW+rqSccI+EoM=;
        b=ElDhTSCMq6kMQomTtJ1Mju9JnTSMEI0p2mPR3t79NDcdZJg1x1OGHthQhiyrnDdQ8D
         Csl6WVuAgXyjyplnLpI5jJK1+yIQgGHRd3pZmd8N05fdjv0oXzPgJHgcpVJDLQMi2zrd
         XrrbJqFBS2erZkOP5hc0fhp5XX49SoYmmyPP2h4brqz3UlYG7K7CbLcA3zm3Oev1ECYe
         JlAqs2p1dAuehjJwsJUTN6wniKt4y3LfvktEGfbTxhT0dSnja8QNQIZ+0jI5Dw1WNevZ
         HO9XmMzVtBd63vQOvUM7/xjClbljhd6kPSCkKGxIojdlMnTs/0BxksByHS3R2OtofAB9
         5xIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc;
        bh=PfjwHn1bJsvfyD146B3GFr85bVvbp9LW+rqSccI+EoM=;
        b=3SasXjx0tOioV13ZjXAYFTu6u3rM/kzoz4s+GQay6W5hzAAKKuuxmUegOyXczweprp
         ymXCUvAq1Buv8JRrc+Nog4MoN0rXZWKRc77i1isQM1WEhHEW+VcP6eb3Q2FoUSlfRK3Y
         CWJBUwOosrF1HjHT7NONZCnNBBdoUoCCuVmPb4YfSabwa6IytxHLov8LINW50cK70irq
         tQNohQz47rKTAsWIaVbmLy8WhconjnmVQC3i21R9SFqH4Hz74XXxCpdiPWtUnkwtSXYI
         iv5InfrT9hTOIht082zUM1OWEEJHTKwXMZ+Y3xKtXC79c7lY+Fz/vPgUyGcKUrzlZcQ/
         i/vg==
X-Gm-Message-State: ACgBeo1DTiWoT7yLEZoMkQj8QAw9TkuAcacJw7S1UlPBbJOLqJgBxVP0
        myQgn59aRzAvQ50u9VbEtLXguta3ebMXOCgTsg==
X-Google-Smtp-Source: AA6agR6TsUwYUmt5+Q3y/EmIPq3RHm1ER0Yg2nGHZBBdDBw8tdLg8tnQ+wNNHe+0Ky1NaJdgBJwjx61o22y6XQCK2g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:1554:b0:688:87a6:e1a4 with
 SMTP id h20-20020a056602155400b0068887a6e1a4mr11468340iow.49.1661886131658;
 Tue, 30 Aug 2022 12:02:11 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:02:10 +0000
In-Reply-To: <YwlFcGn4w34uXPQd@google.com> (message from David Matlack on Fri,
 26 Aug 2022 15:13:04 -0700)
Mime-Version: 1.0
Message-ID: <gsntilm9wo5p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 2/3] KVM: selftests: Randomize which pages are written
 vs read.
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Wed, Aug 17, 2022 at 09:41:45PM +0000, Colton Lewis wrote:
>> Randomize which tables are written vs read using the random number
>> arrays. Change the variable wr_fract and associated function calls to
>> write_percent that now operates as a percentage from 0 to 100 where X
>> means each page has an X% chance of being written. Change the -f
>> argument to -w to reflect the new variable semantics. Keep the same
>> default of 100 percent writes.

> Doesn't the new option cause like a 1000x slowdown in "Dirty memory
> time"?  I don't think we should merge this until that is understood and
> addressed (and it should be at least called out here so that reviewers
> can be made aware).


I'm guessing you got that from my internally posted tests. This option
itself does not cause the slowdown. If this option is set to 0% or 100%
(the default), there is no slowdown at all. The slowdown I measured was
at 50%, probably because that makes branch prediction impossible because
it has an equal chance of doing a read or a write each time. This is a
good thing. It's much more realistic than predictably alternating read
and write.

I can see this would be worth mentioning.

>> @@ -433,10 +434,11 @@ int main(int argc, char *argv[])
>>   		case 'b':
>>   			guest_percpu_mem_size = parse_size(optarg);
>>   			break;
>> -		case 'f':
>> -			p.wr_fract = atoi(optarg);
>> -			TEST_ASSERT(p.wr_fract >= 1,
>> -				    "Write fraction cannot be less than one");
>> +		case 'w':
>> +			perf_test_args.write_percent = atoi(optarg);
>> +			TEST_ASSERT(perf_test_args.write_percent >= 0
>> +				    && perf_test_args.write_percent <= 100,
>> +				    "Write percentage must be between 0 and 100");

> perf_test_create_vm() overwrites this with 100. Did you mean
> p.write_percent?


I did.
