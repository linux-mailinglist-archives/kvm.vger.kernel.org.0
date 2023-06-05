Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5497228BE
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjFEOXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjFEOXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:23:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2710699;
        Mon,  5 Jun 2023 07:23:42 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355EBx6X021338;
        Mon, 5 Jun 2023 14:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C5qfCaTMHEHO+vDnzV1+E782guMMmTJXdeVnSidYHcU=;
 b=rQDX6iywt9nTncpiqWq+edfAiZ23wNZYsClS11AgrALw1Wjaqt8+yrzGOmmbD0uAj72z
 uwxl0PpE633bCM6f8JbPaLEnxUdX/QGBZVc3kJB1I5MS+8V3p6q8I+CK8yu0vn33R4q8
 6Wu6NZ+n2u7D4LAotmW6hNu9E0gp1to5TM8qAKHz0mwTAUXdpc+jp8//HdmAVijKK/wd
 ZCgNKjhtFOqfWfCQMtexoLaWlFJtpS+uTjxQyTRd27SnSbbO4J4V7L+MQUPoQ9gWwUtv
 HZVmNrV1MA0/UQZPzF/lmvQwfeC0BLdEm/JB2gbsgoq9im9W0AW+korik3KNnUht/cLb VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1h8r8ajc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 14:23:41 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 355EDas9027412;
        Mon, 5 Jun 2023 14:23:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1h8r8ahn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 14:23:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3553v2Kd031609;
        Mon, 5 Jun 2023 14:23:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qyxg2hd7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 14:23:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355ENZMB58851790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 14:23:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 282CD20043;
        Mon,  5 Jun 2023 14:23:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D196C20040;
        Mon,  5 Jun 2023 14:23:34 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 14:23:34 +0000 (GMT)
Message-ID: <d393f6b8-0f29-85f0-5ced-8f0a6ceba214@linux.ibm.com>
Date:   Mon, 5 Jun 2023 16:23:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v3 1/6] lib: s390x: introduce bitfield for
 PSW mask
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-2-nrb@linux.ibm.com>
 <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
 <20230605123555.4f865f2c@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230605123555.4f865f2c@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d_25OPEg7nG_pGAphl69r_e0sQJpN0n-
X-Proofpoint-ORIG-GUID: IU6siJMa008XQee7M6_cKGEHiHOE-oF5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_28,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=841 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306050123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/5/23 12:35, Claudio Imbrenda wrote:
> On Thu, 1 Jun 2023 09:42:48 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
> [...]
> 
>> Hrm, since I already made the mistake of introducing bitfields with and
>> without spaces between the ":" I'm in no position to complain here.
>>
>> I'm also not sure what the consensus is.
> 
> tbh I don't really have an opinion, I don't mind either, to the point
> that I don't even care if we mix them
> 
>>
>>> +		};
>>> +	};
>>>    	uint64_t	addr;
>>>    };
>>
>> I've come to like static asserts for huge structs and bitfields since
>> they can safe you from a *lot* of headaches.
> 
> you mean statically asserting that the size is what it should be?
> in that case fully agree
> 

Yes, asserting the size.

