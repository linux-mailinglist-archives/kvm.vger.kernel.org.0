Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B295948D884
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiAMNKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:10:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13202 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234959AbiAMNKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 08:10:08 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DCso5J017408;
        Thu, 13 Jan 2022 13:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ouY80jtVL1VCDs3bS4HPpqdDZ12WoUyhrB3fb/vfGyA=;
 b=bxLlDdiJ/u/lyI7vdGyHOlxF9DQ4uM+8AFByr5mLYPfkwt5UhBV9/4wyjYPFCWJftEQt
 uqFcshQpBe2rOfWTilgi9ImZq40Y+ewilSZGGqg0GvqJfeGOG/2zNbCFvMXmfCK1GVti
 wfOv2FVI4oX6zDmx1/pkhks6FHTThafvPDIEl3+zOwno3nKKMeaBB8qQ5DdCo8lmGaPg
 PCjBy1NtRZjEl/UatfysVxLcfRE18BSAHLgQ8Jwk5kRf8ou7D3yfML3PM3/DVNq7aU34
 y+md44jmmVr5AJOEcaCyUypL5xwgnzSNyOOzK5cENVBXht0NuxQPWMuB73azlejDaiJT ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djgkanayn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 13:10:07 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DCtBMf020755;
        Thu, 13 Jan 2022 13:10:07 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djgkanaxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 13:10:07 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DD7TTD001984;
        Thu, 13 Jan 2022 13:10:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3df28a2jud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 13:10:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DDA1m432178686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 13:10:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAD6E11C050;
        Thu, 13 Jan 2022 13:10:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8245611C052;
        Thu, 13 Jan 2022 13:10:01 +0000 (GMT)
Received: from [9.145.16.55] (unknown [9.145.16.55])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 13:10:01 +0000 (GMT)
Message-ID: <62524574-a3c9-9024-7655-2a59725e557f@linux.ibm.com>
Date:   Thu, 13 Jan 2022 14:10:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 7/8] s390x: snippets: Add PV support
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
References: <20211123103956.2170-1-frankja@linux.ibm.com>
 <20211123103956.2170-8-frankja@linux.ibm.com>
 <20211123122219.3c18cf98@p-imbrenda>
 <08052bad-b494-c99b-27b3-bcfef0aa94fd@linux.ibm.com>
 <e0708a4f-8747-d1c5-229e-d06c8d67dcda@linux.ibm.com>
In-Reply-To: <e0708a4f-8747-d1c5-229e-d06c8d67dcda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vA6XtNEsHdTJHXsiAVqoYDlK2He7b6Yc
X-Proofpoint-GUID: 9ygml9NnXlQU7LIHubm4CTxL8oblVVNQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 10:29, Janosch Frank wrote:
> On 11/26/21 14:28, Janosch Frank wrote:
>> On 11/23/21 12:22, Claudio Imbrenda wrote:
>>> On Tue, 23 Nov 2021 10:39:55 +0000
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>
[...]
>>> are they supposed to have different addresses?
>>> the C files start at 0x4000, while the asm ones at 0
>>
>> That's a mistake I'll need to fix.
> 
> On second thought this is correct since it's the starting address of the
> component and not the PSW entry. The psw entry is the next argument.
> The C snippets currently have data in the first 4 pages so we can
> encrypt from offset 0.
> 
> The question that remains is: do we need the data at 0x0 - 0x4000?
> The reset and restart PSWs are not really necessary since we don't start
> the snippets as a lpar or in simulation where we use these PSWs.
> The stackptr is just that, a ptr AFAIK so there shouldn't be data on
> 0x3000 (but I'll look that up anyway).

Colleagues have used the C PV snippets over the last few weeks and 
haven't reported any issues. It's time that we bring this into master 
since a lot of upcoming tests are currently based on this series.

@Claudio: Any further comments?

>>
>>>
>>>> +
>>>> +.SECONDARY:
>>>> +%.gobj: %.gbin
>>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>>>> +
>>>> +.SECONDARY:
>>>> +%.hdr.obj: %.hdr
>>>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>>>>     
>>>> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
>>>> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
>>>> -	$(OBJCOPY) -O binary $@ $@
>>>> -	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>>>     
>>>>     .SECONDEXPANSION:
>>>> -%.elf: $$(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>>> +%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
>>>>     	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>>>> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds $(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
>>>> +	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>>>> +		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) $(@:.elf=.aux.o) || \
>>>> +		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
>>>>     	$(RM) $(@:.elf=.aux.o)
>>>>     	@chmod a-x $@
>>>>     
>>>> @@ -114,8 +155,12 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
>>>>     %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
>>>>     	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
>>>>     
>>>> +$(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>>>> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>>>> +
>>>> +
>>>>     arch_clean: asm_offsets_clean
>>>> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d $(SNIPPET_DIR)/c/*.{o,gbin} $(SNIPPET_DIR)/c/.*.d lib/s390x/.*.d
>>>> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
>>>>     
>>>>     generated-files = $(asm-offsets)
>>>>     $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
>>>
>>
> 

