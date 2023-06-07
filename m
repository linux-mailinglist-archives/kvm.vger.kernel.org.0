Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1C5725E68
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 14:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbjFGMPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 08:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240422AbjFGMPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 08:15:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D41BE3;
        Wed,  7 Jun 2023 05:15:42 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357Beb2f003316;
        Wed, 7 Jun 2023 12:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yJHvY3hCL79Iyv50TKe4uoJTIQAFMGCCmuzDrs2jJ4w=;
 b=pz+RVeZfod5JDMUOrSXDX8GbUpOvKHO0GjyyMNwfS47E46aJBUbCBw/nQf8lgPkfFfms
 y+9AIWjPe94aJ9Ns50JvUES9niDZeuuAigB0Fz85LrgBcdC8ylB7ZTJMowbOAKfVbQUK
 /QPf9HnrCjG4lj7yhwkmrMErO+CfIuvi828i5OGqemo1vExuOUAgy6VVMvIZ+X/brrK1
 4bzWyuS7mBvuBcc/SY84p06juob44pGEhTEFpCPMtr6S4jzg32vjzz5K5eliBkZanelc
 DydRa2OUTxsu+cem9DOjHGZPQhhdqe0mtAw3Ry/Y0CfvUoYjET9kb2Lwnkuxw0+Xp3oL VA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2ry417qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:15:41 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3574SvrQ002721;
        Wed, 7 Jun 2023 12:15:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3r2a780amf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:15:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357CFabi33948196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 12:15:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A5102004B;
        Wed,  7 Jun 2023 12:15:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BFCB20040;
        Wed,  7 Jun 2023 12:15:35 +0000 (GMT)
Received: from [9.179.8.138] (unknown [9.179.8.138])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jun 2023 12:15:35 +0000 (GMT)
Message-ID: <923a1168-823b-6771-effc-e0d4d85751e8@linux.ibm.com>
Date:   Wed, 7 Jun 2023 14:15:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 2/6] s390/uvdevice: Add 'Add Secret' UVC
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606180817.3019077-1-seiden@linux.ibm.com>
 <20230606180817.3019077-3-seiden@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606180817.3019077-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: idXSKCJhw5X1QwywlV-B3pg07yjZWdvg
X-Proofpoint-GUID: idXSKCJhw5X1QwywlV-B3pg07yjZWdvg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0 adultscore=0
 mlxlogscore=798 suspectscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/23 20:08, Steffen Eiden wrote:
> Userspace can call the Add Secret Ultravisor Call using IOCTLs on the
> uvdevice. The Add Secret UV call sends an encrypted and
> cryptographically verified request to the Ultravisor. The request
> inserts a protected guest's secret into the Ultravisor for later use.
> 
> The uvdevice is merely transporting the request from userspace to the
> Ultravisor. It's neither checking nor manipulating the request data.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


