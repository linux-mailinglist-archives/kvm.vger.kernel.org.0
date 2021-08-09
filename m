Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C334D3E495E
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 17:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhHIP7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 11:59:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235404AbhHIP7w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 11:59:52 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179FweQG081778;
        Mon, 9 Aug 2021 11:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XR2TQXV7GSOZZCMxW3wnJXB0vnxCjRLO8P1uf/pVHC4=;
 b=Q4ITKHURGCdPmOW7oPPc7CYfruGyFR+kEcJgCMT1t48dVNYbxaEF6hwFcdJi8uNTCMUJ
 kUFGfVlnW1FxwAAyufRji1hKMKTE+SMSfG/eYLWDpMYdesr07XTGJ2ff3hNLOTMt+Nwl
 ibGzbfyn991jQ5FHdvMbjeous52/xgqLM66F5/H5Oahas96n1Tk0bKJtiFpBqQad7QBk
 NUwtgdnfjg8TyyPny8u1tm76T0uJXbwXR1TFcq1UzE22zj7qz5+gTA/+C964nqTfZyOU
 I4gs2UGKwPNmMEVbsvSeVvQ8qbpDfjz5SUagff9gbYnqjmlqbptByTOLsteDa6w/53qz vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aax6c7udw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 11:59:31 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179FxPmq084323;
        Mon, 9 Aug 2021 11:59:31 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aax6c7udb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 11:59:31 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179Fv51R022551;
        Mon, 9 Aug 2021 15:59:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8v8qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 15:59:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179FuF0N57016688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 15:56:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48E3FAE058;
        Mon,  9 Aug 2021 15:59:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E779DAE057;
        Mon,  9 Aug 2021 15:59:24 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 15:59:24 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: Topology: checking
 Configuration Topology Information
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-5-git-send-email-pmorel@linux.ibm.com>
 <20210809122212.6dbaafea@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b33060f3-9863-0cc2-d075-0c979041e1dc@linux.ibm.com>
Date:   Mon, 9 Aug 2021 17:59:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809122212.6dbaafea@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: McexzfWcJzpKD6cgD-eqFVROK7swO2cp
X-Proofpoint-ORIG-GUID: AQD0X0npiOBQTjwVkl0GT6tg0sFBVqHQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_05:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 12:22 PM, Claudio Imbrenda wrote:
> On Mon,  9 Aug 2021 10:48:54 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> STSI with function code 15 is used to store the CPU configuration
>> topology.
>>
...
>>   
>> +static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info)
>> +{
>> +	struct topology_container *tc, *end;
>> +	struct topology_core *cpus;
>> +	int nb_nl0 = 0, nb_nl1 = 0, nb_nl2 = 0, nb_nl3 = 0;
>> +
>> +	if (mnest > 5)
>> +		report(info->mag6 == 0, "topology level 6");
>> +	if (mnest > 4)
>> +		report(info->mag5 == nodes, "Maximum number of
>> nodes");
>> +	if (mnest > 3)
>> +		report(info->mag4 == drawers, "Maximum number of
>> drawers");
>> +	if (mnest > 2)
>> +		report(info->mag3 == books, "Maximum number of
>> book");
> 
> * books

right, thanks

...

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
