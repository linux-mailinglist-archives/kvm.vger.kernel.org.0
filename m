Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D93F725F3C
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 14:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbjFGMZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 08:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbjFGMYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 08:24:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8151735;
        Wed,  7 Jun 2023 05:24:52 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357CF20d019742;
        Wed, 7 Jun 2023 12:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RVjBk97CzqjGiGb+k13zICDADHCgSP9dUP+PFAVrSaY=;
 b=f5XkSwrLwrQpslxEaVT2TUXxS2EG0ta7XUpa0SWeuWPMwD07xByb0/EdAufyRxCQeanB
 RToqMG/murSX6kcTTZLM39tQDHrP7dhAUxap9PtKfQEo5dbmPAtyYDO9jCvo8nzRk5xX
 BgAoV5WrenzDpt0++Hv7ewh3HLAkfgwdnYpdpnr6zqfl9ZOPd85rMgm47209FCy+fyvZ
 G620v40rB9VrFxB7IkWpYUD02i/ys6zxECQDjKm4cqjRHnC8r1p+UAGewHVYHL7efrl2
 ln3Pazkh+2fBE6RQnhXomoSa+zF5KEMrFFdcTvXLUoDAY2oghne8t2gPND73JV/iztU/ Tw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2sr0r9kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:24:51 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3574kjZH005507;
        Wed, 7 Jun 2023 12:24:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3r2a77gawc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:24:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357COieI20513390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 12:24:45 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D009B20040;
        Wed,  7 Jun 2023 12:24:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55A3720043;
        Wed,  7 Jun 2023 12:24:44 +0000 (GMT)
Received: from [9.179.8.138] (unknown [9.179.8.138])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jun 2023 12:24:44 +0000 (GMT)
Message-ID: <11b9ff22-1d18-5659-47d5-c30a3bfdf909@linux.ibm.com>
Date:   Wed, 7 Jun 2023 14:24:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 4/6] s390/uvdevice: Add 'Lock Secret Store' UVC
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606180817.3019077-1-seiden@linux.ibm.com>
 <20230606180817.3019077-5-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606180817.3019077-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eCVr0Kl0I_Nl7ObDxKx81d1kbZYG8MfZ
X-Proofpoint-GUID: eCVr0Kl0I_Nl7ObDxKx81d1kbZYG8MfZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=750
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306070100
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
> Userspace can call the Lock Secret Store Ultravisor Call
> using IOCTLs on the uvdevice. The Lock Secret Store UV call
> disables all additions of secrets for the future.
> 
> The uvdevice is merely transporting the request from userspace to the
> Ultravisor.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
