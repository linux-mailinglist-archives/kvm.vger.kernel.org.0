Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9D9537904
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiE3KYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 06:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiE3KYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 06:24:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9ED7C16B;
        Mon, 30 May 2022 03:24:15 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U9OkDm018338;
        Mon, 30 May 2022 10:24:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TkPShSIqR7IPAaTfXZ/l/J5JsMi96HBJOqYWSfdSBs0=;
 b=AeMbsmbaMr3h7DFpZ2jdeftC09l6Hp7GTyI4x/EmprHVmmj9Xbs+u+bwO7CDpMvixsNv
 DW/aHn3aNMnJmeTzJML6AlANWYKDb6nYPILxtf+QfBdtouKDhmzOKNStiYFsB6dnhQGw
 l1wBdYdoiwjeRf3thXuf7iAazeF+r9fT10qqpdNjwIdwbAy4JmMYuQtpHV45Zwuc2U5j
 uRsakDyRAbFCWZuhiHtYc5cOGwmfF83jQud/U6yCi+8ezdcrjpGw3lH356q4HizwgluL
 3L1v9ht/g9VnDzHMGRTfS1m/81+aGiUdAuRDdpoLXdo10EtE6F27R4EFB7JI3tbELo73 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcu95136p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:24:14 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UAMItK010227;
        Mon, 30 May 2022 10:24:14 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcu951366-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:24:14 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UAJuMD007670;
        Mon, 30 May 2022 10:24:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7hwbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:24:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UAO9ru50463078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 10:24:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3491D4C044;
        Mon, 30 May 2022 10:24:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B232B4C040;
        Mon, 30 May 2022 10:24:08 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 10:24:08 +0000 (GMT)
Message-ID: <f23fd9bcfed138c4a18080cb6af45641971366a9.camel@linux.ibm.com>
Subject: Re: [PATCH v10 17/19] KVM: s390: pv: add
 KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 30 May 2022 12:24:08 +0200
In-Reply-To: <20220414080311.1084834-18-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-18-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3uz1BIoS9whtemtrxnKakovFO-uOEgAd
X-Proofpoint-GUID: RUxO8D-ovJF9PK0lAqcxZX4nysiKr4D6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=783 priorityscore=1501
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
> Add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE to signal that the
> KVM_PV_ASYNC_DISABLE and KVM_PV_ASYNC_DISABLE_PREPARE commands for
> the
> KVM_S390_PV_COMMAND ioctl are available.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
