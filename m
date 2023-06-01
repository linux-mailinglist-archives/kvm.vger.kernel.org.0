Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA09719B60
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjFAMAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbjFAMAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:00:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C21A4;
        Thu,  1 Jun 2023 04:59:51 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351Bi43Z000591;
        Thu, 1 Jun 2023 11:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : subject : cc : from : to : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LIFYsAtjXNhbO0Yo1BCt8bKFc14Btz6K4FKgg3HM66Q=;
 b=aGLa6n6qy/kjzcBdl5OcK1JcOV6nFFxy3LkNI7AhDZv3r/mkeMofo8KeckwLVS6ZKC+L
 rI7ZO3UNv6Z8lmSTJ4yIBml73cholVyOlhcSJprp4W8MGUnhSU6918Agir9aQ7aXa2PX
 eGuf/g2pgRlaE9b7aItYhg01s4zXGqPA9DurFT6Lzi2qokHRUa6Jo91Tq85aGAXysXdG
 reOEIjDJx6U9QS/GoMRkbUM2SrCk6kJpPAqx3NGUpqGXuXMsqH8csBanhutZ51YuKI6w
 vAiV2QEePIt4VLJI6kA/Ina5e/p4u41iQFItgV1tsKpEnxD/stlPl5NlLlRHqAv+T8F1 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxtqeref6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 11:59:49 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351BtISN005671;
        Thu, 1 Jun 2023 11:59:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxtqeree9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 11:59:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3515w9B2028420;
        Thu, 1 Jun 2023 11:59:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qu94e2gph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 11:59:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351Bxhub22872748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 11:59:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18A120067;
        Thu,  1 Jun 2023 11:59:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B93AA20040;
        Thu,  1 Jun 2023 11:59:43 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.95.43])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 11:59:43 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <3dc8e019-a3c1-8446-08ed-f76a9064f954@linux.ibm.com>
References: <20230530124056.18332-1-pmorel@linux.ibm.com> <20230530124056.18332-3-pmorel@linux.ibm.com> <3dc8e019-a3c1-8446-08ed-f76a9064f954@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: sclp: Implement SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com, cohuck@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168562078341.164254.16306908045401776634@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 01 Jun 2023 13:59:43 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ahVdUWfGUZ2ePkVLJk3AU7cY44jHiC7u
X-Proofpoint-ORIG-GUID: 6z0sZRHIUgNG_mNWGOritwVMNIvQJZxN
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxlogscore=941
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-01 10:03:06)
> On 5/30/23 14:40, Pierre Morel wrote:
> > If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
> > with a greater buffer.
> >=20
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Janosch, I think it makes sense if Pierre picks up Claudios suggestion from=
 here:
https://lore.kernel.org/all/20230530173544.378a63c6@p-imbrenda/

Do you agree?
