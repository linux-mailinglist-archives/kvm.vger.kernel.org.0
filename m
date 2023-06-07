Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68F272653E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbjFGP4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241551AbjFGP4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:56:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AE32698;
        Wed,  7 Jun 2023 08:56:20 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357FjTgM014366;
        Wed, 7 Jun 2023 15:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=LUPpjfzpO0Rj1zfk7zHetfYZPjxFAKbSfTpnjgMTI1M=;
 b=rCxzsOraKh/CWUAcr3Yvlese3adLUTqmRVkrMYoXGa/05B/v2Hcvf5Qsu8vIr+dmQljP
 IZbcvtNPq28FGf/XdVyLc9nbGO8jX1jPNMHazpmeZRLE2tgSLLxPOjLqOdlASg2UXTnb
 sHBvgbo00sKEoC11wHtV5AB/acDXUykARe6/Z6KHWt2oqZZupq7/+xgobiJlgi75baNs
 DYzBtSap1svoxP3h5m4G14lribR1xloa3oWpHAQpVZie9RLrJC04LRaWdB+QG3LRn06N
 pYDuO10tIweOXb5s2CZI85FfxPo/8E8wlhb7f4MgLkgiyUf8RywX+/WqhZBh6TDSTWyb 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2v2bsmp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 15:56:19 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 357FduB5027835;
        Wed, 7 Jun 2023 15:56:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2v2bsmnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 15:56:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3575WXsQ030622;
        Wed, 7 Jun 2023 15:56:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r2a77gjun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 15:56:16 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357FuDMk6488650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 15:56:13 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C2B120043;
        Wed,  7 Jun 2023 15:56:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 868AA2004B;
        Wed,  7 Jun 2023 15:56:13 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.84])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jun 2023 15:56:13 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com> <20230601070202.152094-2-nrb@linux.ibm.com> <3667d7af-f9ba-fbb6-537d-e6143f63ac43@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/6] lib: s390x: introduce bitfield for PSW mask
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Message-ID: <168615337335.127716.6745745533225595281@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 07 Jun 2023 17:56:13 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y5o-8yo_VJQ8Fc8hKRec4yjVYmux7Dz5
X-Proofpoint-GUID: IUFe5KEzjdQnCZBVilykEBNZyQSg8QzB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_07,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=745 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-01 09:42:48)
[...]
> I've come to like static asserts for huge structs and bitfields since=20
> they can safe you from a *lot* of headaches.

I generally agree and I add a _Static_assert but I want to mention the
usefulness is a bit limited in this case, since we have a bitfield inside a
union. So it only really helps if you manage to exceed the size of mask.

There really is no way around the stuff I put in the selftests.

I could of course try to make that code _Static_asserts but it will not be
pretty.
