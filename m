Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897495377DE
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiE3JsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiE3JsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:48:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A7F26119;
        Mon, 30 May 2022 02:48:01 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U9XuLY013204;
        Mon, 30 May 2022 09:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Hzm8c5/8EdQNvMJmMuq7BOHj90yRQFACoXyiplHq1Vc=;
 b=ZWQrjlBVZPlsZebsw/18WEh4xr0GUd0vNeH8T9MLRhxrblIsriZRmuljjTg+yXGIVOJI
 OgVqD0dA8s771JUG43V/jul+1HhXTih08UZWuf1yPLfnF20cL8CDhGTHJ8xsvzToQPFD
 4GtjoKua98Z70VJtKYS5HfVRIwSfMj0iv99bCC1Iw625yyPBR8DGZGWCrdZYEqF+7YSs
 EwOiEzL6AUgC/RVNSile7SqfD173NfVUKAZFHGU3vXm1s3UdwM0/q41OJ97O1gjqaOED
 L2KX9Sx6J/3ghYdE+wQpwsBSbb9gxgbdf2j7nmogOftSj9wSN1EMccpMAgNd9Vtm4ARY mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcudgg7pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:48:00 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U9dHsL030107;
        Mon, 30 May 2022 09:47:59 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcudgg7p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:47:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U9cvvk006956;
        Mon, 30 May 2022 09:47:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gbbynjgqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:47:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U9kqfD32702770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 09:46:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 034C2A4054;
        Mon, 30 May 2022 09:47:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DDFAA405B;
        Mon, 30 May 2022 09:47:54 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 09:47:54 +0000 (GMT)
Message-ID: <3a02e7f632de52a2d6dcb63a5b8a17f92336c3ab.camel@linux.ibm.com>
Subject: Re: [PATCH v10 16/19] KVM: s390: pv: api documentation for
 asynchronous destroy
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 30 May 2022 11:47:54 +0200
In-Reply-To: <20220414080311.1084834-17-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-17-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hbu-QZdWyNhqF1raQcJI76uWCXGpYGGj
X-Proofpoint-ORIG-GUID: 33Oha-7OFQBKJl0XvaEfaYD7JnaFSPow
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=861 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
> Add documentation for the new commands added to the
> KVM_S390_PV_COMMAND
> ioctl.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
