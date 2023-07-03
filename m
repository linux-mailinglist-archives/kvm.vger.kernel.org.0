Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66B5745B3B
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 13:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjGCLgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 07:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjGCLgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 07:36:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DD5EC;
        Mon,  3 Jul 2023 04:36:12 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 363BHg96014742;
        Mon, 3 Jul 2023 11:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cf5+9VNZKsIGT5SX30dCdiMEZ3tX2QpDwfBK1a09qio=;
 b=hzi1WEsCWduKElrOK7cj7oWINueNp1mpKidFtz0yJJdQZopVWmLZf5oTK8oys6/CplTL
 I/dlP2yh531VdN93MbfKJd6MORfDSsIBStHg/yTAzQYAzyU2qTwnJ4XDLGEq8zYLdx43
 oo5HWBdhxgTPU9e67LdU3iGwmhmGzzgEUHOH5e/xNaUGzyQ8/zB2WVHlQz6S+N8Btz4O
 3Cz/WBraMoTG5Yg011B58iAOsmeBKQc1xa1gvalIZuc6o0Rsp0nYTGrp/LHQa+7KROqk
 E0sE6ERaEzCWOaPkWeMNUImanIjzFoiz1ZhXZMVhhIfHulU5+fp9/KzyboXW8RC4r8sw 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkwax0efh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:36:11 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 363BIMiD017266;
        Mon, 3 Jul 2023 11:36:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkwax0ed8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:36:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3633CWqd023137;
        Mon, 3 Jul 2023 11:36:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rjbde19r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:36:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 363Ba5RT20513420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jul 2023 11:36:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAB6E2004B;
        Mon,  3 Jul 2023 11:36:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E82020043;
        Mon,  3 Jul 2023 11:36:05 +0000 (GMT)
Received: from [9.171.11.162] (unknown [9.171.11.162])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jul 2023 11:36:05 +0000 (GMT)
Message-ID: <74940751-4aab-3bb5-d294-3e73e3049a95@linux.ibm.com>
Date:   Mon, 3 Jul 2023 13:36:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests RFC 2/3] lib: s390x: sclp: Clear ASCII screen on
 setup
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
References: <20230630145449.2312-1-frankja@linux.ibm.com>
 <20230630145449.2312-3-frankja@linux.ibm.com>
 <20230630172558.3edfa9ec@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230630172558.3edfa9ec@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MQuBXoTT9TClraNXJK_Cul5wlHQufJiK
X-Proofpoint-GUID: H9LZA3CzpVQLYf1cNBb8siOG8_PBrPIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-03_08,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307030100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/23 17:25, Claudio Imbrenda wrote:
> On Fri, 30 Jun 2023 14:54:48 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> In contrast to the line-mode console the ASCII console will retain
> 
> what's the problem with that?

It can be a bit hard to read since you need to find the line where the 
old output ends and the new one starts.


I don't insist on this patch being included, the \r and sclp line mode 
input patches give me enough usability.
