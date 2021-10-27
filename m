Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0962343C73C
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbhJ0KDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:03:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33738 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241493AbhJ0KCu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:02:50 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R9pxmd030186;
        Wed, 27 Oct 2021 10:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CDUNR6m+If0jMQUi2cldh/Fajci9f4UgxjWcahISUFY=;
 b=cZE57fQp9f5OqLnq8bQWgKlre1jp6u9+XyqcYOLWFDM3gAoAXd7PNvedngUKILC9Z7po
 gUu6P/Vs6G41tNLvjFUtK8Ods/l07YXegJgsXFbmxx+38K/HLFzDj+DfTBJRp4JYk6X1
 66YjIJ4DRY9BZKp7oUdmX/SKzGo9E1H8QWOYaJOYklPCSOybeKTn1buMp4OwBAeXMJxq
 zBzdiJfBq/FVvphWPZBfxGMjnzzs2BYHhmdJ2X/AvECJYxcPnvfMEJON8WAjwhEGqWtH
 DC65JcxQQQ+7GiIQUCrH6izTkoBXxqYa5gjxL1Qg6qAY5ZNX8sgF2KoPSuQIOPfwjGFH UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3by3n19597-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:00:23 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19R9tAcJ007534;
        Wed, 27 Oct 2021 10:00:23 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3by3n1957x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:00:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19R9vmmZ000997;
        Wed, 27 Oct 2021 10:00:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bx4edwpxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:00:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RA0H7u55050522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 10:00:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47DD111C069;
        Wed, 27 Oct 2021 10:00:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE87311C05E;
        Wed, 27 Oct 2021 10:00:16 +0000 (GMT)
Received: from [9.171.92.208] (unknown [9.171.92.208])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 10:00:16 +0000 (GMT)
Message-ID: <7649d08e-bc5c-512d-fb70-c2b9b512fc42@linux.vnet.ibm.com>
Date:   Wed, 27 Oct 2021 12:00:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: Add specification exception
 test
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022120156.281567-1-scgl@linux.ibm.com>
 <20211022120156.281567-2-scgl@linux.ibm.com>
 <20211025191722.31cf7215@p-imbrenda>
 <d7b701ba-785f-5019-d2e4-a7eb30598c8f@linux.vnet.ibm.com>
 <20211026154113.1a9ab666@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <20211026154113.1a9ab666@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BUR42g-g3pXL6-NmDG_DsZOgXMCeND8L
X-Proofpoint-GUID: L8KNRlNckv2mhNKauFv4lIWd8w733Wws
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 phishscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/21 15:41, Claudio Imbrenda wrote:
> On Tue, 26 Oct 2021 14:00:31 +0200
> Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com> wrote:
> 
> [...]
> 
>> I don't think that would work, the compiler might inline the function,
>> duplicating the label.
> 
> __attribute__((noinline))
> 
> :)

+ a comment on why it's necessary and at that point I don't think it's worth it.
> 
>> I suppose I could replace the stg with an assignment in C, not sure if that's nicer.
>>
>>>> +	fixup_psw.mask = extract_psw_mask();  
>>>
>>> then you could add this here:
>>> 	fixup_psw.addr = after_lpswe;
>>>   
>>>> +	asm volatile (
>>>> +		"	larl	%[scratch],nop%=\n"
>>>> +		"	stg	%[scratch],%[addr]\n"  
>>> 	^ those two lines are no longer needed ^  
>>>> +		"	lpswe	%[psw]\n"
>>>> +		"nop%=:	nop\n"  
>>> 	".global after_lpswe \n"
>>> 	"after_lpswe:	nop"  
>>>> +		: [scratch] "=&r"(scratch),
>>>> +		  [addr] "=&T"(fixup_psw.addr)
>>>> +		: [psw] "Q"(psw)
>>>> +		: "cc", "memory"
>>>> +	);
>>>> +}
> 
> [...]
>  
>> That's nicer indeed.
>>>   
>>>> +	asm volatile ("lpq %0,%2"
>>>> +		      : "=r"(r1), "=r"(r2)  
>>>
>>> since you're ignoring the return value, can't you hardcode r6, and mark
>>> it (and r7) as clobbered? like:
>>> 		"lpq 6, %[bad]"
>>> 		: : [bad] "T"(words[1])
>>> 		: "%r6", "%r7" 
>>>   
>> Ok, btw. is there a reason bare register numbers seem to be more common
>> compared to %%rN ?
> 
> I don't know, I guess laziness?
> 
>>
>>>> +		      : "T"(*bad_aligned)
>>>> +	);
>>>> +}
>>>> +
>>>> +static void not_even(void)
>>>> +{
>>>> +	uint64_t quad[2];
>>>> +
>>>> +	register uint64_t r1 asm("7");
>>>> +	register uint64_t r2 asm("8");
>>>> +	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq
>>>> %0,%2  
>>>
>>> this is even uglier. I guess you had already tried this?
>>>   
>> Yes, the assembler won't let you do that.
> 
> yeah I thought so
> 
>>
>>> 		"lpq 7, %[good]"
>>> 			: : [good] "T"(quad)
>>> 			: "%r7", "%r8"
>>>
>>> if that doesn't work, then the same but with .insn
> 
> I guess you can still try this ^ ?

Ok.
> 
>>>   
>>>> +		      : "=r"(r1), "=r"(r2)
>>>> +		      : "T"(quad)
>>>> +	);
>>>> +}
>>>> +
>>>> +struct spec_ex_trigger {
>>>> +	const char *name;
>>>> +	void (*func)(void);
>>>> +	void (*fixup)(void);
>>>> +};
>>>> +
>>>> +static const struct spec_ex_trigger spec_ex_triggers[] = {
>>>> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
>>>> +	{ "bad_alignment", &bad_alignment, NULL},
>>>> +	{ "not_even", &not_even, NULL},
>>>> +	{ NULL, NULL, NULL},
>>>> +};
>>>> +  
>>>
>>> this is a lot of infrastructure for 3 tests... (or even for 5 tests,
>>> since you will add the transactions in the next patch)  
>>
>> Is it? I think we'd want a test for a "normal" specification exception,
>> and one for an invalid PSW at least. Even for just those two, I don't
>> think it would be nice to duplicate the test_spec_ex harness.
> 
> usually we do duplicate code for simple tests, so that reviewers have
> an easier time understanding what's going on, on the other hand..
> 
>>>
>>> are you planning to significantly extend this test in the future?  
>>
>> Not really, but I thought having it be easily extensible might be nice.
> 
> ..fair enough
> 
> this way it will be easier to extend this in the future, even though we
> don't have any immediate plans to do so
> 
> maybe add some words in the patch description, and some comments, to
> explain what's going on, to make it easier for others to understand
> this code

Ok.
> 
>>>   
>>>> +struct args {
>>>> +	uint64_t iterations;
>>>> +};
>>>> +
>>>> +static void test_spec_ex(struct args *args,
>>>> +			 const struct spec_ex_trigger *trigger)
>>>> +{
>>>> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
>>>> +	uint16_t pgm;
>>>> +	unsigned int i;
>>>> +
>>>> +	for (i = 0; i < args->iterations; i++) {
>>>> +		expect_pgm_int();
>>>> +		register_pgm_cleanup_func(trigger->fixup);
>>>> +		trigger->func();
>>>> +		register_pgm_cleanup_func(NULL);
>>>> +		pgm = clear_pgm_int();
>>>> +		if (pgm != expected_pgm) {
>>>> +			report_fail("Program interrupt: expected(%d)
>>>> == received(%d)",
>>>> +				    expected_pgm,
>>>> +				    pgm);
>>>> +			return;
>>>> +		}
>>>> +	}
>>>> +	report_pass("Program interrupt: always expected(%d) ==
>>>> received(%d)",
>>>> +		    expected_pgm,
>>>> +		    expected_pgm);
>>>> +}
>>>> +
>>>> +static struct args parse_args(int argc, char **argv)  
>>>
>>> do we _really_ need commandline arguments?
>>>   
>> No, but they can be useful.
>> The iterations argument can be used to check if interpretation happens.
>> The transaction arguments can be useful while developing a test case.
>>
>>> is it really so important to be able to control these parameters?
>>>
>>> can you find some values for the parameters so that the test works (as
>>> in, it actually tests what it's supposed to) and also so that the whole
>>> unit test ends in less than 30 seconds?  
>>
>> I think the defaults are fine for that, no?
> 
> ok so they are only for convenience in case things go wrong?

Yes, for when you want to poke at it manually for whatever reason.
> 
>>>   
>>>> +{
>>>> +	struct args args = {
>>>> +		.iterations = 1,
>>>> +	};
>>>> +	unsigned int i;
>>>> +	long arg;
>>>> +	bool no_arg;
>>>> +	char *end;
>>>> +
>>>> +	for (i = 1; i < argc; i++) {
>>>> +		no_arg = true;
>>>> +		if (i < argc - 1) {
>>>> +			no_arg = *argv[i + 1] == '\0';
>>>> +			arg = strtol(argv[i + 1], &end, 10);
>>>> +			no_arg |= *end != '\0';
>>>> +			no_arg |= arg < 0;
>>>> +		}
>>>> +
>>>> +		if (!strcmp("--iterations", argv[i])) {
>>>> +			if (no_arg)
>>>> +				report_abort("--iterations needs a
>>>> positive parameter");
>>>> +			args.iterations = arg;
>>>> +			++i;
>>>> +		} else {
>>>> +			report_abort("Unsupported parameter '%s'",
>>>> +				     argv[i]);
>>>> +		}
>>>> +	}
> 
> I wonder if we can factor out the parameter parsing

I don't think it's worth it. Only three arguments are handled the same.
Doing this might be worthwhile tho:

        for (i = 1; i < argc; i++) {                                            
                no_arg = true;                                                  
                if (i < argc - 1) {                                             
                        no_arg = *argv[i + 1] == '\0';                          
                        arg = strtol(argv[i + 1], &end, 10);                    
                        no_arg |= *end != '\0';                                 
                        no_arg |= arg < 0;                                      
                }                                                               
                                                                                
                cmp = "--iterations";                                           
                argp = &args.iterations;                                        
                if (!strcmp(cmp, argv[i])) {                                    
                        if (no_arg)                                             
                                report_abort("%s needs a positive parameter", cmp);
                        *argp = arg;                                            
                        ++i;                                                    
                        continue;                                               
                }                                                               
                cmp = "--max-retries";                                          
                argp = &args.max_retries;                                       
                if (!strcmp(cmp, argv[i])) {                                    
                        if (no_arg)                                             
                                report_abort("%s needs a positive parameter", cmp);
                        *argp = arg;                                            
                        ++i;                                                    
                        continue;                                               
                }                                                               
                cmp = "--suppress-info";                                        
                argp = &args.suppress_info;                                     
                if (!strcmp(cmp, argv[i])) {                                    
                        if (no_arg)                                             
                                report_abort("%s needs a positive parameter", cmp);
                        *argp = arg;                                            
                        ++i;                                                    
                        continue;                                               
                }                                                               
                cmp = "--max-failures";                                         
                argp = &args.max_failures;                                      
                if (!strcmp(cmp, argv[i])) {                                    
                        max_failures = true;                                    
                                                                                
                        if (no_arg)                                             
                                report_abort("%s needs a positive parameter", cmp);
                        *argp = arg;                                            
                        ++i;                                                    
                        continue;                                               
                }                                                               
                if (!strcmp("--diagnose", argv[i])) {                           
                        args.diagnose = true;                                   
                        continue;
		}                                              
                if (!strcmp("--no-diagnose", argv[i])) {                        
                        args.diagnose = false;                                  
                        continue;                                               
                }                                                               
                report_abort("Unsupported parameter '%s'",                      
                             argv[i]);                                          
        }
> 
>>>> +	return args;
>>>> +}
>>>> +
>>>> +int main(int argc, char **argv)
>>>> +{
>>>> +	unsigned int i;
>>>> +
>>>> +	struct args args = parse_args(argc, argv);
>>>> +
>>>> +	report_prefix_push("specification exception");
>>>> +	for (i = 0; spec_ex_triggers[i].name; i++) {
>>>> +		report_prefix_push(spec_ex_triggers[i].name);
>>>> +		test_spec_ex(&args, &spec_ex_triggers[i]);
>>>> +		report_prefix_pop();
>>>> +	}
>>>> +	report_prefix_pop();
>>>> +
>>>> +	return report_summary();
>>>> +}
>>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>>> index 9e1802f..5f43d52 100644
>>>> --- a/s390x/unittests.cfg
>>>> +++ b/s390x/unittests.cfg
>>>> @@ -109,3 +109,6 @@ file = edat.elf
>>>>  
>>>>  [mvpg-sie]
>>>>  file = mvpg-sie.elf
>>>> +
>>>> +[spec_ex]
>>>> +file = spec_ex.elf  
>>>   
>>
> 

