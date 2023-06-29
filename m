Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A347426BE
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjF2MyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 08:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF2MyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 08:54:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7234294C;
        Thu, 29 Jun 2023 05:54:07 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35TCkx4o013273;
        Thu, 29 Jun 2023 12:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XsotPbubv7VKhTXtRVfupeqVKA9cFM0F/u2coSt2H40=;
 b=Xu4COxTbR/t4Nvmh5w5XQUF7JBNrrDVRwdEnoEzRMq8KCkBfKfhoPtpZHbCMVbs/TOc9
 4tGp46YmE4iyH5C0uiTKA/c7ebAbSM8NOJ7suf+jMJAyP6Ivo/CLiNXI9G4fryyNIeVo
 Wl7sfzkQlLLfNFEevF9wTC1isnupZOpxEtrtF0IiyK79SCzFVLGoZWoZEPeMhrcOeaFB
 +nUPHxNHG2n9D9yn9Iv/YEE412Db025J/dnBqmaXmNY57FeptFFT3vv4vJ2ceUoNvqH4
 D+InySkWx4lzFOccQigexhz+9SAgTKllhXU6KgEZtikpEI8E7ty3wJwe3pg3Yl/1POaj vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rha90878d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 12:54:07 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35TClM2h013971;
        Thu, 29 Jun 2023 12:54:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rha90876v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 12:54:06 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35TCb8TK028153;
        Thu, 29 Jun 2023 12:54:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rdr452gvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 12:54:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35TCs0nc18023074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:54:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F2232004B;
        Thu, 29 Jun 2023 12:54:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2728420040;
        Thu, 29 Jun 2023 12:54:00 +0000 (GMT)
Received: from [9.171.67.162] (unknown [9.171.67.162])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 29 Jun 2023 12:54:00 +0000 (GMT)
Message-ID: <9ecf65f7-877b-188c-4308-f16ad4fd5ab7@linux.ibm.com>
Date:   Thu, 29 Jun 2023 14:53:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v10 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-2-pmorel@linux.ibm.com>
 <168802854091.40048.12063023827984391132@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168802854091.40048.12063023827984391132@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iIL55UvPFcXir0wpTjWTb2fDtXTS7jMd
X-Proofpoint-ORIG-GUID: C1dIg4P9KniuRGCQGrx5WRfV_fI5m8fs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-29_03,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290112
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/29/23 10:49, Nico Boehr wrote:
> Quoting Pierre Morel (2023-06-27 10:21:54)
> [...]
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..7e1bbf9
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,190 @@
> [...]
>> +static void check_privilege(int fc)
>> +{
>> +       unsigned long rc;
>> +       char buf[20];
>> +
>> +       snprintf(buf, sizeof(buf), "Privileged fc %d", fc);
>> +       report_prefix_push(buf);
> We have report_prefix_pushf (note the f at the end!) for this.
>
> I can fix that up when picking in case there's no new version, though.


ohhh, perfect.

Yes please if you can, do it :)

Thanks

Pierre

