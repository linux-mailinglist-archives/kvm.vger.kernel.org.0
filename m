Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0338C58D849
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 13:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbiHILhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 07:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiHILhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 07:37:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07D9C59;
        Tue,  9 Aug 2022 04:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660045059; x=1691581059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kIiAO74hYt1dzWOtgOZtkirGU+z075hBgRLKvW2Haj4=;
  b=L8CWcFh3ADeOklVQDoqlVrtKDUniqT/sPU5lhwBC42wLXa1WleY1SO+c
   LsmmLl0V1yy5E9Gf+NH39Il2+Sq2R+77JVjBgzOV/+9IGvKpUI0y+Mpec
   /3wTYULMWDP+sFDYHJXbVQdI0Ct95+EIhmBIdBEBn2y3s6qZQbqay/hEM
   eoVuSpLoW+eDpXU2QnDxkUlRCnPgjTubqeyS7bsQgi9bRp420AIrOQqdo
   F7w+Vg8/SKgQiEJSAPyOO40kmXnZ7yuW3+KDMMwC6l+IyO4ZEECP6FtAM
   uHu533LuX4vjWjqb+T5Hj9nYp6cWXkbocjhoU1PGub6b0BoKzKOOntGkN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="377104079"
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="377104079"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 04:37:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="932449395"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.48.82])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 04:37:37 -0700
Message-ID: <1ab5d302-afef-1f31-7e26-a0b7c522aadb@intel.com>
Date:   Tue, 9 Aug 2022 14:37:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 04/35] perf tools: Export
 perf_event__process_finished_round()
Content-Language: en-US
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-5-adrian.hunter@intel.com>
 <CAP-5=fVbfiVJXAHcZV+3bqc-bV3XfbpxKVVtZtH+jJauzh9NQQ@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAP-5=fVbfiVJXAHcZV+3bqc-bV3XfbpxKVVtZtH+jJauzh9NQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/22 20:04, Ian Rogers wrote:
> On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> Export perf_event__process_finished_round() so it can be used elsewhere.
>>
>> This is needed in perf inject to obey finished-round ordering.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/session.c | 12 ++++--------
>>  tools/perf/util/session.h |  4 ++++
>>  2 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 37f833c3c81b..4c9513bc6d89 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -374,10 +374,6 @@ static int process_finished_round_stub(struct perf_tool *tool __maybe_unused,
>>         return 0;
>>  }
>>
>> -static int process_finished_round(struct perf_tool *tool,
>> -                                 union perf_event *event,
>> -                                 struct ordered_events *oe);
>> -
>>  static int skipn(int fd, off_t n)
>>  {
>>         char buf[4096];
>> @@ -534,7 +530,7 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
>>                 tool->build_id = process_event_op2_stub;
>>         if (tool->finished_round == NULL) {
>>                 if (tool->ordered_events)
>> -                       tool->finished_round = process_finished_round;
>> +                       tool->finished_round = perf_event__process_finished_round;
>>                 else
>>                         tool->finished_round = process_finished_round_stub;
>>         }
>> @@ -1069,9 +1065,9 @@ static perf_event__swap_op perf_event__swap_ops[] = {
>>   *      Flush every events below timestamp 7
>>   *      etc...
>>   */
>> -static int process_finished_round(struct perf_tool *tool __maybe_unused,
>> -                                 union perf_event *event __maybe_unused,
>> -                                 struct ordered_events *oe)
>> +int perf_event__process_finished_round(struct perf_tool *tool __maybe_unused,
>> +                                      union perf_event *event __maybe_unused,
>> +                                      struct ordered_events *oe)
>>  {
>>         if (dump_trace)
>>                 fprintf(stdout, "\n");
>> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
>> index 34500a3da735..be5871ea558f 100644
>> --- a/tools/perf/util/session.h
>> +++ b/tools/perf/util/session.h
>> @@ -155,4 +155,8 @@ int perf_session__deliver_synth_event(struct perf_session *session,
>>  int perf_event__process_id_index(struct perf_session *session,
>>                                  union perf_event *event);
>>
>> +int perf_event__process_finished_round(struct perf_tool *tool,
>> +                                      union perf_event *event,
>> +                                      struct ordered_events *oe);
>> +
> 
> Sorry to be naive, why is this  perf_event__ and not perf_session__ ..

No idea, but it is fairly consistent for tool callback functions.

> well I guess it is at least passed an event even though it doesn't use
> it. Would be nice if there were comments, but this change is just
> shifting things around. Anyway..
> 
> Acked-by: Ian Rogers <irogers@google.com>
> 
> Thanks,
> Ian
> 
>>  #endif /* __PERF_SESSION_H */
>> --
>> 2.25.1
>>

